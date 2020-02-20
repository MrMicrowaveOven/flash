# == Schema Information
#
# Table name: cameras
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contact_number  :string
#  last_checked_in :datetime         default(Mon, 17 Feb 2020 21:06:09 UTC +00:00)
#  mac_address     :string
#

require 'test_helper'

class CameraTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
