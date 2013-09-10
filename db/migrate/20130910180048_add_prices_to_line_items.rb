class AddPricesToLineItems < ActiveRecord::Migration
  def change
    add_column :line_items, :price, :decimal
    add_column :line_items, :subtotal, :decimal
  end
end
