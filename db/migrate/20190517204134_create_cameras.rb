class CreateCameras < ActiveRecord::Migration[5.2]
  def change
    create_table :cameras do |t|
      t.string :phone_number
      t.string :tunnel_url

      t.timestamps
    end
  end
end
