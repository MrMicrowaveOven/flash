class SmsController < ApplicationController

  XML_RESPONSE = '<Response></Response>'

  def create
    require 'twilio-ruby'
    require 'net/http'

    from, to, body = params['From'], params['To'], params['Body']

    if from
      account_sid, auth_token = ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']

      raise 'No Twilio environment variables were found' unless account_sid and auth_token
      @client = Twilio::REST::Client.new(account_sid, auth_token)

      if body.downcase.include?('update')
        send_update_text
      else
        send_intro_text

        id_in_body = body.scan(/\d/).join.to_i
        camera = Camera.find_by_id(id_in_body)

        if camera&.active?
          camera.pictures.create(phone_number: from)
        else
          message = send_camera_not_found_text
          puts 'CAMERA_NOT_FOUND ERROR'
        end
      end
    end
    render xml: XML_RESPONSE
  end

  def response_text(response)
    if response.include?('CAMERA ERROR')
      'CAMERA ERROR'
    elsif response.include?('EXPIRED')
      'EXPIRATION ERROR'
    elsif response == ''
      'CAMERA NOT TRANSMITTING ERROR'
    else
      'UNKNOWN ERROR'
    end
  end

  def send_picture_text(picture_url)
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      media_url: picture_url
    )
  end

  def send_update_text
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: "Happy to update for you!  Your camera will be updated shortly.",
    )
    @client.messages.create(
      from: params['To'],
      to: Camera.first.contact_number,
      body: "Camera seeks update",
    )
  end

  def send_intro_text
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: "Thank you for using FLASH!  I'll be sending your picture soon.",
    )
  end

  def send_camera_not_found_text
    cameras = Camera.active.pluck(:id).sort
    camera_list = cameras.to_sentence
    camera_sentence = if camera_list.empty?
                        'Sorry, I currently do not have any cameras online.'
                      else
                        "Sorry, I didn't find a camera with that ID.  I currently have camera#{'s' if cameras.length > 1} #{camera_list} online.#{'  Which would you like?' if cameras.length > 1}"
                      end
    @client.messages.create(
      from: params['To'],
      to: params['From'],
      body: camera_sentence,
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
