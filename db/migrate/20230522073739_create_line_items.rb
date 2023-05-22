class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.belongs_to :store, null: false, foreign_key: true
      t.belongs_to :user, null: false, foreign_key: true
      
      t.integer :qty, default: 1
      t.integer :status, default: 0


      t.timestamps
    end
  end
end
