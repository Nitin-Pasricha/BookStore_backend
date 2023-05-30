class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.belongs_to :order, null: false, foreign_key: true
      t.belongs_to :store, null: false, foreign_key: true
      t.integer :qty, default: 0

      t.timestamps
    end
  end
end
