class SmsController < ApplicationController
  def create
    from = params["From"]

    require 'rubygems'
    require 'twilio-ruby'

    require 'net/http'

    if from
      account_sid = ENV['TWILIO_SID']
      auth_token = ENV['TWILIO_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)

      message = @client.messages.create(
        from: '+14152124906',
        to: from,
        body: "Thank you for using FLASH!  I'll be sending your picture soon.",
      )

      response = Net::HTTP.get('0beca4aa.ngrok.io', '/')

      if response.index('http') == 0
        message = @client.messages.create(
          from: '+14152124906',
          to: from,
          media_url: response
        )
      elsif response.include?('expired')
        message = @client.messages.create(
          from: '+14152124906',
          to: from,
          body: 'Apologies, this flash-cam is currently out of service.  Please try again later.'
        )
        puts 'EXPIRATION ERROR'
      else
        message = @client.messages.create(
          from: '+14152124906',
          to: from,
          body: 'Apologies, this flash-cam is currently out of service.  Please try again later.'
        )
        puts 'UNKNOWN ERROR'
      end
      puts message.sid
    end
    render json: params
  end
end
