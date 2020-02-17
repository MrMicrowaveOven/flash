class CamerasController < ApplicationController
  def show
    camera = Camera.find(params[:id])
    camera.touch
    picture = camera.pictures.where(sent_to_user: false).first
    render json: { code: 200, picture_id: picture&.id }
  end
end
