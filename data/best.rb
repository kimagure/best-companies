require 'mongo'
require 'octokit'

include Mongo

mongo_client = MongoClient.new
db = mongo_client.db("best-companies")

Octokit.configure do |c|
  c.login = ENV['github_api_username']
  c.password = ENV['github_api_password']
end

query = 'location:"Virginia" location:"Maryland" location:"DC" location:"D.C."'
popular_va = Octokit.search_users(query, :sort => 'followers', :per_page => 100, :page => 1)
popular_va_items = popular_va.items
for i in 2..10 do
  popular_va_items.concat Octokit.search_users(query, :sort => 'followers', :per_page => 100, :page => i).items
end
puts "Popular DCMA users total: #{popular_va.total_count} Fetched: #{popular_va_items.length}"

mongo_users = db['users']
popular_va_items.each {|item|
  user = item.rels[:self].get.data

  repos = item.rels[:repos].get.data
  languages = [].to_set

  repos.each {|repo|
    languages = languages.merge(repo.rels[:languages].get.data.fields)
  }

  doc = {
    "login" => user.login,
    "id" => user.id,
    "avatar_url" => user.rels[:avatar].href,
    "gravatar_id" => user.gravatar_id,
    "type" => user.type,
    "site_admin" => user.site_admin,
    "name" => user.name,
    "company" => user.company,
    "blog" => user.blog,
    "location" => user.location,
    "email" => user.email,
    "hirable" => user.hirable,
    "bio" => user.bio,
    "public_repos" => user.public_repos,
    "followers" => user.followers,
    "following" => user.following,
    "created_at" => user.created_at,
    "updated_at" => user.updated_at,
    "public_gists" => user.public_gists,
    "languages" => languages.to_a()
  }

  result = mongo_users.update(
    { id: user.id },
    { '$set' => doc },
    { upsert: true }
  )
}

companies = db.collection("users").aggregate([
  {"$match" => {company: {"$ne" => nil}}},
  {"$match" => {company: {"$ne" => ""}}},
  {"$group" => 
    {
      _id: "$company",
      user_avatars: {"$push" => { avatar_url: "$avatar_url"}},
      users_count: {"$sum" => 1},
      language: {"$push" => "$languages"},
    }
  },
  {"$unwind" => "$language"},
  {"$unwind" => "$language"},
  {"$group" =>
    {
      _id: {
        "_id" => "$_id",
        "language" => "$language"
      },
      language_count: {"$sum" => 1},
      user_avatars: { "$first" => "$user_avatars"},
      users_count: { "$first" => "$users_count"}
    }
  },
  {"$group" =>
    {
      _id: "$_id._id",
      languages: {
        "$push" => {
          language: "$_id.language",
          count: "$language_count"
        }
      },
      user_avatars: { "$first" => "$user_avatars"},
      users_count: { "$first" => "$users_count"},
    }
  },
  {"$sort" => {users_count: -1}}
]).find

companies.each {|company|
  company["name"] = company["_id"]
  company.delete("_id")

  result = db['companies'].update(
    { name: company["name"] },
    { '$set' => company },
    { upsert: true }
  )
}