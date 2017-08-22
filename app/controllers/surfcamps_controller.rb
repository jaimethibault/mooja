class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_surfcamp, only: [:show]

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

  def show
    @booking = Booking.new
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end
end
