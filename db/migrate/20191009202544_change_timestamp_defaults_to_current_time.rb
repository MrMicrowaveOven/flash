class ChangeTimestampDefaultsToCurrentTime < ActiveRecord::Migration[5.2]
  def change
    change_column_default :pictures, :created_at, Time.now
    change_column_default :pictures, :updated_at, Time.now
  end
end
