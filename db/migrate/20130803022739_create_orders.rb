class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :number
      t.date :date
      t.integer :rep_id

      t.timestamps
    end

    add_index :orders, :number, unique: true
    add_index :orders, [:rep_id, :date]
  end
end
