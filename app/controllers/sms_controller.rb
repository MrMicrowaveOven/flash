class SmsController < ApplicationController
  def create
    p params
    render json: params
  end
end
