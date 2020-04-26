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

  SECONDS_TO_TIMEOUT = 15

  include ActiveModel::Dirty

  before_save :inform_camera_owners_of_change

  def touch
    update(last_checked_in: Time.now)
  end

  def active?
    last_checked_in > SECONDS_TO_TIMEOUT.seconds.ago
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
  scope :active, lambda { where('last_checked_in > ?', SECONDS_TO_TIMEOUT.seconds.ago) }
end
