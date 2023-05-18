class CreateStores < ActiveRecord::Migration[6.1]
  def change
    create_table :stores do |t|
      t.string :title
      t.string :author
      t.text :description
      t.float :price

      t.timestamps
    end
  end
end
