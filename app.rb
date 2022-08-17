#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'
#require 'sinatra/reloader'


before do
	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
end

configure do
	db = SQLite3::Database.new 'leprosorium.db'
	db.execute 'CREATE TABLE IF NOT EXISTS Posts
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		created_date DATE,
		content TEXT
	)'
end

get '/' do
	erb	"Hello"		
end

get '/new' do
  erb :new
end

post '/new' do
  content = params[:content]

  erb "You typed #{content}"
end
