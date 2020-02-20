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
      send_new_mac_address_notification
    end
  end

  def send_new_mac_address_notification
    require 'twilio-ruby'
    require 'net/http'

    from, to, body = params['From'], params['To'], params['Body']
    account_sid, auth_token = ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)
    @client.messages.create(
      from: '+14152124906',
      to: Camera.first.contact_number,
      body: "New mac address detected",
    )
  end

  def resolved?
    !!Camera.find_by_mac_address(mac_address)
  end
end
