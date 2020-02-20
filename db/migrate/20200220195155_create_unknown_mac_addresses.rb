class CreateUnknownMacAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :unknown_mac_addresses do |t|
      t.string :mac_address
      t.datetime :last_called
      t.timestamps
    end
  end
end
