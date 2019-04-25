class SmsController < ApplicationController
  def create
    render json: {"yo": "World"}
  end
end
