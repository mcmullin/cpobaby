class AddDiscontinuedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :discontinued, :boolean, default: false
  end
end
