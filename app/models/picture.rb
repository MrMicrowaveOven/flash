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

class Picture < ApplicationRecord
  belongs_to :camera

  def send_to_user
    require 'twilio-ruby'
    require 'net/http'

    if phone_number && photo_url
      account_sid, auth_token = ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      raise 'No Twilio environment variables were found' unless account_sid and auth_token

      client = Twilio::REST::Client.new(account_sid, auth_token)
      update!(sent_to_user: true)
      client.messages.create(
        from: '+14152124906',
        to: phone_number,
        media_url: photo_url
      )
    elsif !phone_number && !photo_url
      puts "No phone number or photo_url"
    elsif !phone_number
      puts "No phone number"
    elsif !photo_url
      puts "No photo url"
    end
  end
end
