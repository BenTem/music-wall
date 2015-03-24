# Homepage (Root path)
get '/' do
  @message = params[:message]
  @users = User.all
  @current_user = request.cookies["username"]
  erb :index
end

get '/login' do
  erb :login
end

post '/login' do
  params[:username]
  params[:password]

  users = User.where(username: params[:username]).where(password: params[:password])
  if users.count > 0
    user = users[0]
    response.set_cookie("username", :value => params[:username], :path => "/", :expires => Time.now + 60*60*24*365*3)
    redirect '/'
  else
    # login failed
    redirect '/?message=Failed'
  end
end

get '/signup' do
  erb :signup
end

post '/signup' do
    User.create(username: params[:username], password: params[:password])
    redirect '/'
end

get '/songs' do
  @current_user = request.cookies["username"]
  @songs = Song.all.order(upvotes: :desc)
  erb :'songs/index'
end

get '/songs/new' do
  @current_user = request.cookies["username"]
  @song = Song.new
  erb :'songs/new'
end

post '/songs' do
  @current_user = User.where(username: request.cookies["username"] )
  @song = Song.new(
    song_title: params[:song_title],  
    author: params[:author],
    url:  params[:url],
    upvotes: 0,
    user_id: @current_user.first.id
  )
  if @song.save
    redirect '/songs'
  else
    erb :'songs/new'
  end
end

get '/songs/:id' do
  @current_user = request.cookies["username"]
  @song = Song.find params[:id]
  erb :'songs/show'
end

post '/songs/:id/upvote' do
  @song = Song.find params[:id]
  @current_user = User.where(username: request.cookies["username"] ).first
  association = SongsUser.where(song_id: @song.id, user_id: @current_user.id, voted: true).first

  if !association
    association = SongsUser.create(song_id: @song.id, user_id: @current_user.id, voted: true)
    @song.upvotes += 1
    @song.save
  end

  redirect '/songs'

end

get '/logout' do   
    response.set_cookie("username", :value => '', :path => "/", :expires => Time.now - 60*60*24*365*3)
    redirect '/'
end