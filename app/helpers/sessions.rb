helpers do

  def current_user
    if session[:user_id]
      @current_user  ||= User.find(session[:user_id])
    end
  end

  def authenticate_session
    session[:user_id] ? User.find(session[:user_id]) : false

  rescue ActiveRecord::RecordNotFound
    false
  end

end