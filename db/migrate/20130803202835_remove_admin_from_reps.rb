class RemoveAdminFromReps < ActiveRecord::Migration
  def change
    remove_column :reps, :admin
  end
end
