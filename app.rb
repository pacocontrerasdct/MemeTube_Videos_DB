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
  #@title_of_page = "New tube"


if params[:video_id]
    
    puts 'this is id: ',params[:video_id]
    

    id = params[:video_id]
    title = params[:new_title]
    description = params[:new_description]
    genre = params[:new_genre]
    url = params[:new_url]

    sql = "UPDATE videos SET title = '#{title}', description = '#{description}', genre = '#{genre}', url = '#{url}'  WHERE id = '#{id}' "

    new_video = @db.exec(sql)
 
    puts 'update it' if new_video

    redirect('/home')

  elsif params[:new_title].to_s != ""
    puts 'user has submitted the form'
    puts 'this is tube: ',params[:new_tube]

    title = params[:new_title]
    description = params[:new_description]
    genre = params[:new_genre]
    url = params[:new_url]


    sql = "insert into videos (title, description, genre, url) values ('#{title}', '#{description}', '#{genre}', '#{url}')"

    new_tube = @db.exec(sql)
 
    puts 'did it' if new_tube

    redirect('/home')

  end







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
