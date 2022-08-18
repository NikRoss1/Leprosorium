#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'
#require 'sinatra/reloader'


before do
	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
end

#configure вызывается каждый раз при конфигурации приложения
#Когда изменился код программы И перезагрузилась страница

configure do 
	#инициализация базы данных
	db = SQLite3::Database.new 'leprosorium.db'

	#создает таблицу если таблица не существует
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
	#получаем переменную из POST запроса

  content = params[:content]

  erb "You typed #{content}"
end
