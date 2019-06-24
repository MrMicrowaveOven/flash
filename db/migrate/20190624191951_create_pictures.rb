class CreatePictures < ActiveRecord::Migration[5.2]
  def change
    create_table :pictures do |t|
      t.references :camera, foreign_key: true
      t.string :phone_number
      t.string :photo_url
    end
  end
end
