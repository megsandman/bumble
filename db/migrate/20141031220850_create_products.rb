class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :designer
      t.integer :price
      t.text :description
      t.string :category
      t.text :url
      t.string :image
      t.string :image_2
      t.string :image_3
      t.string :image_4
      t.timestamps
    end
  end
end
