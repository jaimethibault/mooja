class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    if params[:maxprice].nil?
      @surfcamps = Surfcamp.all
    else
      @surfcamps = Surfcamp.joins(:rooms).where("price_per_night < ?", params[:maxprice]).distinct
    end
  end

  def surfcamp_params
    params.require(:surfcamp).permit(:name, :description, :photo)
  end
end
