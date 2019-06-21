desc "Test all cameras, sms response"
task :camera_test => :environment do
  p 'Beginning camera test'
  require 'rubygems'
  require 'twilio-ruby'

  require 'net/http'

  account_sid = ENV['TWILIO_SID']
  auth_token = ENV['TWILIO_TOKEN']
  @client = Twilio::REST::Client.new(account_sid, auth_token)

  Camera.find_each do |camera|
    p "Testing Camera ##{camera.id}"
    response = Net::HTTP.get(camera.tunnel_url, '/')
    p "Camera ##{camera.id}"
    p response
    p @client.messages.create(
      from: '+14152124906',
      to: '+17148099426',
      body: "Camera ##{camera.id}: #{response.slice(0, 10)}"
    )
    sleep 10
  end
end
