class ChangeProductColumnNames < ActiveRecord::Migration
  def change
    change_table :products do |t|
      t.rename :current_retail_price, :retail
      t.rename :current_cpo, :cpo
      t.rename :current_point_value, :points
    end
  end
end
