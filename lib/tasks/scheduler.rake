desc "Test all cameras, sms response"
task :camera_test => :environment do
  Camera.camera_test
end
