# == Schema Information
#
# Table name: unknown_mac_addresses
#
#  id          :bigint           not null, primary key
#  mac_address :string
#  last_called :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'test_helper'

class UnknownMacAddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
