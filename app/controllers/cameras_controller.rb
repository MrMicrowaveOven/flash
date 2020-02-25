class CamerasController < ApplicationController
  def index
    camera = Camera.find_by_mac_address(params['mac_address'])
    if camera
      camera.touch
      picture = camera.pictures.where(sent_to_user: false).first
      if params['test']
        render json: { code: 200, picture_id: nil, mac_address: true}
      else
        render json: { code: 200, picture_id: picture&.id }
      end
    else
      UnknownMacAddress.inform(params['mac_address'])
      if params['test']
        render json: { code: 200, picture_id: nil, mac_address: false}
      end
    end
  end
end
