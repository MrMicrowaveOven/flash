class SmsController < ApplicationController
  def create
    from = params['From']
    to = params['To']
    body = params['Body']

    require 'rubygems'
    require 'twilio-ruby'

    require 'net/http'

    if from
      account_sid = ENV['TWILIO_SID']
      auth_token = ENV['TWILIO_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)

      send_intro_text

      id_in_body = body.scan(/\d/).join.to_i
      camera = Camera.find_by_id(id_in_body)

      if camera
        response = Net::HTTP.get(camera.tunnel_url, '/')

        if response.index('http') == 0
          message = @client.messages.create(
            from: to,
            to: from,
            media_url: response
          )
        elsif response.include?('CAMERA ERROR')
          message = send_error_text
          puts 'CAMERA ERROR'
          puts response
        elsif response.include?('EXPIRED')
          message = send_error_text
          puts 'EXPIRATION ERROR'
          puts response
        else
          message = send_error_text
          puts 'UNKNOWN ERROR'
          puts response
        end
      else
        message = send_error_text
        puts 'CAMERA_NOT_FOUND ERROR'
      end
      puts message.sid
    end
    render xml: '<Response></Response>'
  end
  def send_intro_text
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: "Thank you for using FLASH!  I'll be sending your picture soon.",
    )
  end

  def send_error_text
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: 'Apologies, this flash-cam is currently out of service.  Please try again later.'
    )
  end
end
