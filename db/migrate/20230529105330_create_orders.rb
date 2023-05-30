class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.float :amount, default: 0
      t.integer :status, default: 0
      t.datetime :order_date

      t.timestamps
    end
  end
end
