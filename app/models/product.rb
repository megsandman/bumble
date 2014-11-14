class Product < ActiveRecord::Base

  has_many :actions
  has_many :users, through: :actions

  validates :name, :designer, :amazon_ASIN, presence: true

  validates :amazon_ASIN, uniqueness: true


  # returns product id of user's last action
  def self.next_product_id(user)
    eligible_products = Product.where("content_approved = ? AND disabled = ?", true, false).order(:id)

    if user.has_actions?
      if user.user_last_action_product_id >= eligible_products.last.id
        return (-1)
      else
        p user.user_last_action_product_id
        p eligible_products.last.id
        p eligible_products.where("id > #{user.user_last_action_product_id}").limit(1)
        return eligible_products.where("id > #{user.user_last_action_product_id}").first.id
      end
    else
      return eligible_products.first.id
    end
  end

end


# if user has no actions
  # return the product id for the first eligible product_id

# if user has actions
  # 1) find product id of their last action
  # 2) find product id of last eligible product
  # 3) if 1 and 2 are equal, return -1
  # 4) if 1 and 2 are NOT equal
    # find a list of all items with id greater than id from 1, limit list to 1