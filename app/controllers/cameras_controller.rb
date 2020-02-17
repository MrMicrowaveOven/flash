class CamerasController < ApplicationController
  def index
    p params
    p params[:mac_address]
    p params['mac_address']
    camera = Camera.find_by_mac_address(params['mac_address'])
    p camera
    camera.touch
    picture = camera.pictures.where(sent_to_user: false).first
    render json: { code: 200, picture_id: picture&.id }
  end
end
