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
		content TEXT,
		post_id INTEGER
	)'


	db.execute 'CREATE TABLE IF NOT EXISTS Comments
	(
		id INTEGER PRIMARY KEY AUTOINCREMENT,
		created_date DATE,
		content TEXT,
		post_id
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

# получаем список постов
# (у нас будет только один пост)

	db = SQLite3::Database.new 'leprosorium.db'
	db.results_as_hash = true
	results = db.execute 'select * from Posts where id = ?',[post_id]
	
	# выбираем этот один пост в переменную @row
	@row = results[0]

	# выбираем коментарий для нашего поста
	@comments = db.execute 'select * from Comments where post_id = ? order by id', [post_id]

	# возвращаем представление details.erb
	erb :details
end

# обработчик post запроса /details/...
# (браузер отправляет данные на серве, мы их принемаем)
post '/details/:post_id' do

	# получаем переменную из url'a
	post_id = params[:post_id]

	# получаем переменную из post запроса
	content = params[:content]

	# сохранение данных в БД

	db = SQLite3::Database.new 'leprosorium.db'
  db.execute 'insert into Comments
   (
   	content, 
   	created_date, 
   	post_id
   ) 
   		values 
   	(
   		?, 
   		datetime(),
   	 	?
   	 )', [content, post_id]

# перенаправляем на страницу поста
	#erb "You typed comment #{content} for post #{post_id}"
	redirect to('/details/' + post_id)
end
