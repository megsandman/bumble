class AddColumnsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :amazon_ASIN, :string
    add_column :products, :content_approved, :boolean, default: :false
    add_column :products, :disabled, :boolean, default: :false

  end
end
