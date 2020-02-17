class RemovePhoneNumberAndTunnelUrlFromCameras < ActiveRecord::Migration[5.2]
  def change
    remove_column :cameras, :phone_number, :string
    remove_column :cameras, :tunnel_url, :string
  end
end
