class CamerasController < ApplicationController
  def show
    @camera = Camera.find(params[:id])
    @pictures = @camera.pictures
    # p camera
    p "--------"
    p (params[:id].to_i + 1)
  end
end
