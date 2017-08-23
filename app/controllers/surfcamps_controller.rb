class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_surfcamp, only: [:show]

  def index
    if params[:maxprice].nil?
      @surfcamps = Surfcamp.all.where.not(latitude: nil, longitude: nil)
    else
      @surfcamps = Surfcamp.joins(:rooms).where("price_per_night < ?", params[:maxprice]).distinct
    end

    @hash = Gmaps4rails.build_markers(@surfcamps) do |surfcamp, marker|
      marker.lat surfcamp.latitude
      marker.lng surfcamp.longitude
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def surfcamp_params
    params.require(:surfcamp).permit(:name, :description, :photo)
  end

  def show
    @booking = Booking.new
    @occupancy = Occupancy.new
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end

  def set_params
    params.require(:surfcamp).permit(:name, :description, :rating, :address, :photo)
  end

end
