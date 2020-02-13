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

class Camera < ApplicationRecord
  has_many :pictures
  default_scope { order(:created_at) }

  require 'rubygems'
  require 'twilio-ruby'

  require 'net/http'

  account_sid = ENV['TWILIO_SID']
  auth_token = ENV['TWILIO_TOKEN']
  CLIENT = Twilio::REST::Client.new(account_sid, auth_token)

  include ActiveModel::Dirty

  before_save :inform_camera_owners_of_change

  def inform_camera_owners_of_change
    if contact_number_previous_change
      old_number = contact_number_previous_change[0]
      new_number = contact_number_previous_change[1]

      [old_number, new_number].each do |number|
        p CLIENT.messages.create(
          from: '+14152124906',
          to: number,
          body: "Flash-Cam ##{id} has changed its contact number from #{old_number} to #{new_number}"
        )
      end
    end
  end

  def self.camera_test
    p 'Beginning camera test'
    Camera.find_each do |camera|
      p "Testing Camera ##{camera.id}"
      begin
        response = camera.ping_camera
      rescue
        camera.update(active: false)
      end
      p "Camera ##{camera.id}"
      camera.handle_response(response)
    end
  end

  def handle_response(response)
    if response.index('https://s3') == 0
      active_procedure
    else
      inactive_procedure
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

  def ping_camera
    Net::HTTP.get(tunnel_url, '/')
  end
end
