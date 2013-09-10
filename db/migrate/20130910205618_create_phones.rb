class CreatePhones < ActiveRecord::Migration
  def change
    create_table :phones do |t|
      t.string :number, limit: 12
      t.string :extension, limit: 6
      t.string :country, limit: 6, null: false, default: '1'
      t.string :description

      t.belongs_to :phoneable, polymorphic: true

      t.timestamps
    end

    add_index :phones, [:phoneable_type, :phoneable_id]
  end
end
