class AddActiveAndContactNumberToCameras < ActiveRecord::Migration[5.2]
  def change
    add_column :cameras, :contact_number, :string
    add_column :cameras, :active, :boolean
  end
end
