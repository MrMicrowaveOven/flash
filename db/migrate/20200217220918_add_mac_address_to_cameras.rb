class AddMacAddressToCameras < ActiveRecord::Migration[5.2]
  def change
    add_column :cameras, :mac_address, :string
  end
end
