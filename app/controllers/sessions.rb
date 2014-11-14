get "/signup" do
  @user = User.new
  erb :"sessions/signup"
end

post "/signup" do
  @user = User.new(params[:user])

  if !@user.save
    erb :"sessions/signup"
  else
    session[:user_id] = @user.id
    redirect "/products"
  end
end

get "/login" do
  erb :"sessions/login"
end

post "/login" do
  @user = User.find_by(email: params[:email]) || User.new
  if @user.valid?
    if @user.password == params[:password]
      session[:user_id] = @user.id
      redirect "/products"
    else
      flash[:err] = "Invalid password"
      erb :"sessions/login"
    end
  else
    flash[:err] = "A user with that email does not exist"
    erb :"sessions/login"
  end
end

get "/logout" do
  session[:user_id] = nil
  redirect "/"
end

get '/redirect_auth_url' do
  redirect "https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=https://bumble.herokuapp.com/oauth2callback&response_type=code&client_id=#{ENV['CLIENT_ID_HEROKU']}&approval_prompt=force"
end

get '/oauth2callback' do

  token_response = HTTParty.post("https://accounts.google.com/o/oauth2/token",
    body: {
      code: params[:code],
      client_id: ENV['CLIENT_ID_HEROKU'],
      redirect_uri: "http://localhost:9393/oauth2callback",
      client_secret: ENV['CLIENT_SECRET_HEROKU'],
      grant_type: "authorization_code"
      })

  people_response = HTTParty.get("https://www.googleapis.com/plus/v1/people/me?access_token=#{token_response['access_token']}")
  p people_response

  if people_response["emails"].first["value"]
    if User.find_by email: people_response["emails"].first["value"]
      flash[:err] = "A user with that email already exists"
      redirect '/signup'
    else
      @email = people_response["emails"].first["value"]
    end
  end

  if people_response["displayName"]
    @name = people_response["displayName"]
  end

  user = User.new(email: @email, name: @name, password: SecureRandom.hex)

  if user.save
    session[:user_id] = user.id
    redirect '/products'
  end

end

get '/redirect_auth_url_login' do
  redirect "https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=https://bumble.herokuapp.com/oauth2callback_login&response_type=code&client_id=#{ENV['CLIENT_ID_2_HEROKU']}&approval_prompt=force"
end

get '/oauth2callback_login' do

  token_response = HTTParty.post("https://accounts.google.com/o/oauth2/token",
    body: {
      code: params[:code],
      client_id: ENV['CLIENT_ID_2_HEROKU'],
      redirect_uri: "http://localhost:9393/oauth2callback_login",
      client_secret: ENV['CLIENT_SECRET_2_HEROKU'],
      grant_type: "authorization_code"
      })

  people_response = HTTParty.get("https://www.googleapis.com/plus/v1/people/me?access_token=#{token_response['access_token']}")

  if people_response["emails"].first["value"]
    if User.find_by email: people_response["emails"].first["value"]
      user = User.find_by email: people_response["emails"].first["value"]
      session[:user_id] = user.id
      redirect '/products'
    else
      flash[:err] = "A user with that email does not exist"
      erb :"sessions/login"
    end
  end

end



##TODO
# Add in validations for login and signup