class AddSentToUserToPictures < ActiveRecord::Migration[5.2]
  def change
    add_column :pictures, :sent_to_user, :boolean, default: false
  end
end
