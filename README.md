# When the server receives a text...

1. Create a Picture row, saving the phone_number and camera_id.  sent_to_user will be false by default.
- Create Picture
2. The next call you get from a device, return 'take_picture: true'.
-
3. Upon a picture getting a photo_url, there will be a 'send_picture_to_user' callback.  This also sets sent_to_user to true.

# Calls from devices

1. Heartbeat call.  Respond true if the camera has ANY pictures without a photo_url.  Otherwise false.
2. Photo call.  Set ALL photo_urls within the last minute to the photo_url sent.


# All calls

Create SMS
- Call from User

Index Picture
- Shows all pictures of camera

Show Camera
- Heartbeat call from Device
- Responds True or False

Update Picture
- Photo send from Device
- Updates the OLDEST photo with URL

# Current Calls
Create SMS
- Calls camera, responds to SMS with SMS

Show Camera
- Shows all pictures of camera

Update Camera
- Updates tunnel_url of camera
