class SmsController < ApplicationController
  def create
    p params
    from = params["from"]
    require 'rubygems'
    require 'twilio-ruby'

    # Your Account Sid and Auth Token from twilio.com/console
    # DANGER! This is insecure. See http://twil.io/secure
    if from
      account_sid = ENV['TWILIO_SID']
      auth_token = ENV['TWILIO_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)

      message = @client.messages.create(
                                   from: '+14152124906',
                                   body: 'Hello Nick!',
                                   to: from
                                 )

      puts message.sid
    end
    render json: params
  end
end
