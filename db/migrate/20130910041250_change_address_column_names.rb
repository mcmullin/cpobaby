class ChangeAddressColumnNames < ActiveRecord::Migration
  def change
    change_table :addresses do |t|
      t.rename :line1, :street
      t.rename :line2, :secondary
    end
  end
end
