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

class UnknownMacAddress < ApplicationRecord
  def self.inform(mac_address)
    if unknown_mac_address = UnknownMacAddress.find_by_mac_address(mac_address)
      unknown_mac_address.update(last_called: Time.now)
    else
      UnknownMacAddress.create(mac_address: mac_address, last_called: Time.now)
    end
  end
end
