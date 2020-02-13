class AddLastCheckedInToCameras < ActiveRecord::Migration[5.2]
  def change
    add_column :cameras, :last_checked_in, :datetime
    remove_column :cameras, :active
  end
end
