get '/product/import' do
  @products_to_be_approved = Product.where("content_approved = ? AND disabled = ?", false, false).order(:id)
  erb :"/products/import"
end

# edit product name, designer, price
post '/product/import/:product_id' do
  @product = Product.find(params[:product_id])
  @product.name = params[:edit_name] || @product.name
  @product.designer = params[:edit_designer] || @product.designer
  @product.price = params[:edit_price] || @product.price
  if @product.save
    redirect '/product/import'
  else
    ##ERROR
    p @product.errors
  end

end

# change content approved to true
post '/product/import/:product_id/approve' do
  product = Product.find(params[:product_id])
  product.content_approved = true
  product.save
  # redirect '/product/import'
end

# change enabled to false
post '/product/import/:product_id/delete' do
  product = Product.find(params[:product_id])
  product.disabled = true
  product.save
  redirect '/product/import'
end

# imports items from amazon based on search terms
post '/product/import' do
  SEARCH_KEYWORD = params[:search_keywords]

  api = Amazon::Client.new

  @products = api.call_item_search(SEARCH_KEYWORD)

  @products.each do |product|
    params = api.item_info_hash(product)
    new_product = Product.new(
      name: params[:product_name],
      designer: params[:product_designer],
      price: params[:product_price],
      url: params[:product_url],
      image: params[:product_image],
      image_2: params[:product_image_2],
      image_3: params[:product_image_3],
      image_4: params[:product_image_4],
      amazon_ASIN: params[:product_ASIN]
      )
    if !new_product.save
      p new_product.errors
    end
  end
  redirect '/product/import'
end
