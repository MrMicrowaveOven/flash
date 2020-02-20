class CamerasController < ApplicationController
  def index
    camera = Camera.find_by_mac_address(params['mac_address'])
    if camera
      camera.touch
      picture = camera.pictures.where(sent_to_user: false).first
      render json: { code: 200, picture_id: picture&.id }
    else
      UnknownMacAddress.inform(params['mac_address'])
    end
  end
end
