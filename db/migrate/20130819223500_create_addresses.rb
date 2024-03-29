class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :line1
      t.string :line2
      t.string :city
      t.string :state
      t.string :zip
      # t.integer :addressable_id
      # t.string :addressable_type
      t.belongs_to :addressable, polymorphic: true # equivalent

      t.timestamps
    end

    add_index :addresses, [:addressable_type, :addressable_id]
  end
end
