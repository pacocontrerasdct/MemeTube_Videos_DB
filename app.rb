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

    id = params[:video_id].strip
    title = params[:new_title].downcase.strip
    description = params[:new_description].strip
    genre = params[:new_genre].downcase.strip
    url = params[:new_url].strip

    sql = "UPDATE videos SET title = '#{title}', description = '#{description}', genre = '#{genre}', url = '#{url}'  WHERE id = '#{id}' "

    new_video = @db.exec(sql)
 
    puts 'update it' if new_video

    redirect('/home')

  elsif params[:new_title].to_s != ""
    puts 'user has submitted the form'
    puts 'this is tube: ',params[:new_tube]

    title = params[:new_title].downcase.strip
    description = params[:new_description].strip
    genre = params[:new_genre].downcase.strip
    url = params[:new_url].strip


    sql = "insert into videos (title, description, genre, url) values ('#{title}', '#{description}', '#{genre}', '#{url}')"

    new_tube = @db.exec(sql)
 
    puts 'did it' if new_tube

    redirect('/home')

  end

  erb :new_tube
end

get '/find_tube' do
  # to the next array i'll pass id from videos that match word
  @found_videos = []
  @count = 0
  if params[:find_me].to_s != ""
    @find_me = params[:find_me].downcase
    #puts "find me this:", @find_me 
    finding_fields = ['title', 'genre', 'description']

    finding_fields.each { |find_in| 
      #puts "find_me:", @find_me
      #puts "find_in:", find_in
      sql = "select count(id) from videos where #{find_in} LIKE '%#{@find_me}%' "
      count = @db.exec(sql)
      # Next select a single result
      sql = "select * from videos where #{find_in} LIKE '%#{@find_me}%' "
      result = @db.exec(sql)
      @found_videos << result
    }
    puts "In get find_tube"
    puts @found_videos.class
    
    if @count == 100
      @find_no_video = "Sorry, couldn't find that video on this site, try a different search!"
    else
      @find_no_video = ""
      erb :find_tube
    end
  else
    @find_no_video = "Looks like you didn't introduce your query..."
  end

  erb :find_tube
  
end

get '/update_tube' do
  sql = "SELECT * FROM videos WHERE id = #{params[:id]} LIMIT 1"
  video_row = @db.exec(sql)
  @updated_title = video_row.first['title'].capitalize
  @updated_description = video_row.first['description']
  @updated_genre = video_row.first['genre'].capitalize
  @updated_url = video_row.first['url']
  @video_id = params[:id]
  erb :update_tube
end

get '/delete_tube' do
  id = params[:id]
  sql = "DELETE FROM videos WHERE id = '#{id}' "
  @db.exec(sql)

  redirect('/home')
end
