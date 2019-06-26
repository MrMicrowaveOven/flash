class AddTimestampsToPictures < ActiveRecord::Migration[5.2]
  def change
    add_timestamps :pictures, default: Time.zone.now
    change_column_default :pictures, :created_at, nil
    change_column_default :pictures, :updated_at, nil
  end
end
