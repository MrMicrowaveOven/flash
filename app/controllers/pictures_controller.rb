class PicturesController < ApplicationController
  def update
    picture = Picture.find_by_id(params[:id])
    picture.update(photo_url: params['photo_url'])
    picture.send_to_user
  end
end
