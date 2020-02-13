# == Schema Information
#
# Table name: pictures
#
#  id           :bigint           not null, primary key
#  camera_id    :bigint
#  phone_number :string
#  photo_url    :string
#  created_at   :datetime         default(Sun, 09 Feb 2020 18:24:30 UTC +00:00), not null
#  updated_at   :datetime         default(Sun, 09 Feb 2020 18:24:30 UTC +00:00), not null
#  sent_to_user :boolean          default(FALSE)
#

require 'test_helper'

class PictureTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
