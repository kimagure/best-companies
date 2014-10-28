require 'rubygems'
require 'json'
require 'mongo'
require 'sinatra'

DB = Mongo::Connection.new.db("best-companies")

get '/api/companies' do
  companies = DB.collection("users").aggregate([
    {"$group" => 
      {
        _id: "$company",
        user_avatars: {"$push" => { avatar_url: "$avatar_url"}},
        users_count: {"$sum" => 1}
      }
    },
    {"$sort" => {users_count: -1}},
  ]).find
  companies.to_a.to_json
end

get '/api/users' do
  users = DB.collection("users").find
  users.to_a.to_json
end

get '/*' do
  haml :index
end