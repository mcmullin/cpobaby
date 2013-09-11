class AddShipToBillingToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :ship_to_billing, :boolean, default: true
  end
end
