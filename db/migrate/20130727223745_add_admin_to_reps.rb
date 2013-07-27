class AddAdminToReps < ActiveRecord::Migration
  def change
    add_column :reps, :admin, :boolean, default: false
  end
end
