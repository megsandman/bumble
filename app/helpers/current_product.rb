helpers do

  # returns product object when given product id
  def current_product(product_id)
    Product.find(product_id)
  end
end