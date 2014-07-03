class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :ancestry
      t.timestamps
    end

    create_table :categories_products do |t|
      t.references :category, :null => false
      t.references :product, :null => false
      t.timestamps
    end

    add_index(:categories_products, [:category_id, :product_id], :unique => true)
    add_index :categories, :ancestry
  end
end
