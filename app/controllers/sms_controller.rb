class SmsController < ApplicationController
  def create
    p params
    # from = params["from"]
    require 'rubygems'
    require 'twilio-ruby'

    # Your Account Sid and Auth Token from twilio.com/console
    # DANGER! This is insecure. See http://twil.io/secure
    account_sid = ENV['TWILIO_SID']
    auth_token = ENV['TWILIO_TOKEN']
    @client = Twilio::REST::Client.new(account_sid, auth_token)

    message = @client.messages.create(
                                 from: '+14152124906',
                                 body: 'Hello Nick!',
                                 to: '+17148099426'
                               )

    puts message.sid
    render json: params
  end
end
