class Camera < ApplicationRecord
  has_many :pictures
  default_scope { order(:created_at) }

  require 'rubygems'
  require 'twilio-ruby'

  require 'net/http'

  account_sid = ENV['TWILIO_SID']
  auth_token = ENV['TWILIO_TOKEN']
  CLIENT = Twilio::REST::Client.new(account_sid, auth_token)

  def self.camera_test
    p 'Beginning camera test'

    Camera.find_each do |camera|
      p "Testing Camera ##{camera.id}"
      begin
        response = camera.test_camera
      rescue
        camera.set_as_inactive_and_report
      end
      p "Camera ##{camera.id}"
      if response.index('https://s3') == 0
        camera.active_procedure
      else
        camera.inactive_procedure
      end
    end
  end

  def active_procedure
    if !active
      set_as_active_and_report
    else
      p "Camera ##{id} is still active"
    end
  end

  def inactive_procedure
    if active
      set_as_inactive_and_report
    else
      p "Camera ##{id} is still inactive"
    end
  end

  def set_as_active_and_report
    update(active: true)
    report_active
  end

  def report_inactive
    p CLIENT.messages.create(
      from: '+14152124906',
      to: contact_number,
      body: "Camera ##{id} has just become inactive."
    )
  end

  def report_active
    p CLIENT.messages.create(
      from: '+14152124906',
      to: contact_number,
      body: "Camera ##{id} has just become active."
    )
  end

  def set_as_inactive_and_report
    update(active: false)
    report_inactive
  end

  def test_camera
    Net::HTTP.get(tunnel_url, '/')
  end
end
