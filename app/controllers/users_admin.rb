get "/admin/users" do
  @users = User.order(:id)
  erb :"sessions/users_admin"
end

post "/admin/users/:user_id/edit_access" do
  user = User.find(params[:user_id])
  if user.admin == true
    user.admin = false
    user.save
  else
    user.admin = true
    user.save
  end
  redirect "/admin/users"
end