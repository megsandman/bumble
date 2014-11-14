after do
  ActiveRecord::Base.connection.close
end

get "/" do
  if session[:user_id]
    redirect "/products"
  else
    redirect "/signup"
  end
end

get '/products' do
  @next = Product.next_product_id(User.find(session[:user_id]))
  if (@next == (-1))
    redirect "/product/empty"
  else
    redirect "/products/#{@next}"
  end
end

get "/product/empty" do
  erb :"/products/empty"
end

get "/products/:product_id" do
  @product = Product.find(params[:product_id])
  erb :"/products/product"
end

post "/products/:product_id" do
  @product = Product.find(params[:product_id])
  current_user
  if params[:pass]
    action = Action.create(liked: false)
    @product.actions << action
    @current_user.actions << action
  elsif params[:like]
    action = Action.create(liked: true)
    @product.actions << action
    @current_user.actions << action
  end
  redirect "/products"
end

get "/wishlist/:user_id" do
  @user = User.find(params[:user_id])
  @likes = @user.actions.where(liked: true)

  erb :"/products/wishlist"
end

post "/products/:product_id/users/:user_id" do
  product = Product.find(params[:product_id])
  user = User.find(params[:user_id])
  action = user.actions.where(product_id: product.id).first
  if action.liked == true
    action.update(liked: false)
  else
    action.update(liked: true)
  end
  # redirect "/wishlist/#{params[:user_id]}"
end
