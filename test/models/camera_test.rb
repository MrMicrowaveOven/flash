# == Schema Information
#
# Table name: cameras
#
#  id             :bigint           not null, primary key
#  phone_number   :string
#  tunnel_url     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  contact_number :string
#  active         :boolean
#

require 'test_helper'

class CameraTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
