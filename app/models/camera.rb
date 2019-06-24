class Camera < ApplicationRecord
  default_scope { order(:created_at) }
  def self.camera_test
    p 'Beginning camera test'
    require 'rubygems'
    require 'twilio-ruby'

    require 'net/http'

    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    Camera.find_each do |camera|
      p "Testing Camera ##{camera.id}"
      response = Net::HTTP.get(camera.tunnel_url, '/')
      p "Camera ##{camera.id}"
      if response.index('https://s3') == 0
        if !camera.active
          camera.update(active: true)
          p @client.messages.create(
            from: '+14152124906',
            to: camera.contact_number,
            body: "Camera ##{camera.id} has just become active."
          )
        else
          p "Camera ##{camera.id} is still active"
        end
        p response
        p @client.messages.create(
          from: '+14152124906',
          to: '+17148099426',
          body: "Camera ##{camera.id} is working.}"
        )
      else
        if camera.active
          camera.update(active: false)
          p @client.messages.create(
            from: '+14152124906',
            to: camera.contact_number,
            body: "Camera ##{camera.id} has just become inactive."
          )
        else
          p "Camera ##{camera.id} is still inactive"
        end
        p response
        p @client.messages.create(
          from: '+14152124906',
          to: '+17148099426',
          body: "Camera ##{camera.id}: #{response.slice(0, 10)}"
        )
      end
    end
  end
end
