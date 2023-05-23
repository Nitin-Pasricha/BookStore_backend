class AddStatusToStores < ActiveRecord::Migration[6.1]
  def change
    add_column :stores, :status, :integer, default: 0
  end
end
