require 'rubygems'
require 'json'
require 'mongo'
require 'sinatra'

DB = Mongo::Connection.new.db("best-companies")

get '/api/companies' do
  companies = DB.collection("companies").find
  companies.to_a.to_json
end

get '/api/users' do
  users = DB.collection("users").find
  users.to_a.to_json
end

get '/*' do
  haml :index
end