class SmsController < ApplicationController
  def create
    from = params['From']
    to = params['To']

    require 'rubygems'
    require 'twilio-ruby'

    require 'net/http'

    if from
      account_sid = ENV['TWILIO_SID']
      auth_token = ENV['TWILIO_TOKEN']
      @client = Twilio::REST::Client.new(account_sid, auth_token)

      send_intro_text

      camera = Camera.find_by_phone_number(to) || Camera.find_by_phone_number('+1' + to)

      if camera
        response = Net::HTTP.get(camera.tunnel_url, '/')

        if response.index('http') == 0
          message = @client.messages.create(
            from: to,
            to: from,
            media_url: response
          )
        elsif response.include?('camera error')
          message = send_error_text
          puts 'CAMERA ERROR'
        elsif response.include?('expired')
          message = send_error_text
          puts 'EXPIRATION ERROR'
        else
          message = send_error_text
          puts 'UNKNOWN ERROR'
        end
      else
        message = send_error_text
        puts 'CAMERA_NOT_FOUND ERROR'
      end
      puts message.sid
    end
    render text: response, content_type: 'text/html'
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
