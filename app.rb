require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry'
require 'pg'

before do
  @db = PG.connect(dbname: 'memetube', host: 'localhost')
end

after do
  @db.close
end


get '/' do
  @title_of_page = "index"
  redirect('/home')

end

get '/home' do
  @title_of_page = "home"
  
  sql = "select * from videos ORDER BY title DESC"
  @list = @db.exec(sql)

  erb :home
end

get '/views/styles.css' do
  "Hello World"
end

get '/new_tube' do
  @title_of_page = "New tube"

  

  
  erb :new_tube
end

get '/find_tube' do
  @title_of_page = "find tube"
  erb :find_tube
end

get '/update_tube' do
  
end

get '/delete_tube' do
  
end
