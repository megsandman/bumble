class User < ActiveRecord::Base
  has_many :actions
  has_many :products, through: :actions

  validates :name, :email, :password,  presence: true
  validates :email, uniqueness: true
  validates :password, length: { minimum: 6 }
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :create

  # returns true if user has any actions, false if not
  def has_actions?
    if self.actions == []
      return false
    else
      return true
    end
  end

  def user_last_action_product_id
    if self.has_actions?
      self.actions.order(:product_id).last.product_id
    else
      return (-1)
    end
  end

# def password=(new_password)
#     @password = Password.create(new_password)
#     self.password_hash = @password
#   end

#   def password
#     @password ||= Password.new(password_hash)
#   end

end

