# == Schema Information
#
# Table name: cameras
#
#  id              :bigint           not null, primary key
#  phone_number    :string
#  tunnel_url      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  contact_number  :string
#  last_checked_in :datetime
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

  def touch
    update(last_checked_in: Time.now)
  end

  def active?
    last_checked_in > 5.seconds.ago
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
  scope :active, lambda { where('last_checked_in > ?', 5.seconds.ago) }
end
