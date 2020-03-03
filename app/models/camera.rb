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

  def self.inactivity_check
    Camera.all.each do |camera|
      if camera.last_checked_in < 30.seconds.ago && camera.last_checked_in > 31.seconds.ago
        camera.inform_camera_owners_of_inactivity
      end
    end
  end

  def activity_check
    if last_checked_in < 31.seconds.ago
      inform_camera_owners_of_activity
    end
  end

  def touch
    activity_check
    update(last_checked_in: Time.now)
  end

  def active?
    last_checked_in > 30.seconds.ago
  end

  def inform_camera_owners_of_activity
    p CLIENT.messages.create(
      from: '+14152124906',
      to: contact_number,
      body: "Flash-Cam ##{id} has just become active."
    )
  end

  def inform_camera_owners_of_inactivity
    p CLIENT.messages.create(
      from: '+14152124906',
      to: contact_number,
      body: "Flash-Cam ##{id} has been inactive for 30+ seconds."
    )
  end

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
  scope :active, lambda { where('last_checked_in > ?', 30.seconds.ago) }
end
