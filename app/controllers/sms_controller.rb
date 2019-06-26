class SmsController < ApplicationController
  def create
    from = params['From']
    to = params['To']
    body = params['Body']

    if body.downcase.strip == 'camera_test'
      Camera.camera_test
      return
    end

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
        begin
          response = Net::HTTP.get(camera.tunnel_url, '/')
        rescue StandardError => e
          message = send_error_text(id_in_body)
          puts 'HTTP RESPONSE TIMEOUT ERROR, SERVEO IS DOWN'
          puts e
        else
          if response.index('http') == 0
            message = @client.messages.create(
              from: to,
              to: from,
              media_url: response
            )
            Picture.create(camera: camera, phone_number: from, photo_url: response)
          elsif response.include?('CAMERA ERROR')
            message = send_error_text(id_in_body)
            puts 'CAMERA ERROR'
            puts response
          elsif response.include?('EXPIRED')
            message = send_error_text(id_in_body)
            puts 'EXPIRATION ERROR'
            puts response
          elsif response == ''
            message = send_error_text(id_in_body)
            puts 'CAMERA NOT TRANSMITTING ERROR'
            puts response
          else
            message = send_error_text(id_in_body)
            puts 'UNKNOWN ERROR'
            puts response
          end
        end
      else
        message = send_camera_not_found_text
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

  def send_camera_not_found_text
    camera_list = Camera.pluck(:id).sort.to_sentence
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: "Sorry, I didn't find a camera with that ID.  I have cameras #{camera_list}.  Which would you like?",
    )
  end

  def send_error_text(id)
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: "Apologies, Flash-Cam ##{id} is currently out of service.  Please try again later."
    )
  end
end
