class CamerasController < ApplicationController
  def show
    @camera = Camera.find(params[:id])
    @pictures = @camera.pictures
  end

  def update
    Camera.find_by_id(params['id']).update!(tunnel_url: params['url'])
    render json: {code: 200}
  end
end
