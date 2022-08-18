#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sqlite3'
#require 'sinatra/reloader'

# befor вызывается каждый раз при перезагрузке
# любой страницы

before do
	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
end

#configure вызывается каждый раз при конфигурации приложения
#Когда изменился код программы И перезагрузилась страница

configure do 
	#инициализация базы данных БД
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
	# выбрать список постов из БД
	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
	@results = db.execute 'select * from Posts order by id desc'

	erb	:index		
end

# обработчик get-запроса
# браузер получает страницу с сервера

get '/new' do
  erb :new
end

# обработчик post-запроса /new
# браузер отправляет данные на сервер

post '/new' do
	#получаем переменную из POST запроса

  content = params[:content]

  if content.length <= 0
  	@error = 'Type post text'
  	return erb :new
  end

  # сохранение данных в ДБ

  db = SQLite3::Database.new 'leprosorium.db'
  db.execute 'insert into Posts (content, created_date) values (?, datetime())', [content]

# перенаправление на главную страницу

redirect to '/'
end

# вывод информации о посте

get '/details/:post_id' do
	post_id = params[:post_id]

	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
	results = db.execute 'select * from Posts where id = ?',[post_id]
	@row = results[0]

	erb :details
end