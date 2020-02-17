class CamerasController < ApplicationController
  def index
    camera = Camera.find_by_mac_address(params[:mac_address])
    camera.touch
    picture = camera.pictures.where(sent_to_user: false).first
    render json: { code: 200, picture_id: picture&.id }
  end
end
