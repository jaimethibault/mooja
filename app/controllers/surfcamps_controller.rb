class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_surfcamp, only: [:show]

  def index
    if params[:maxprice].nil?
      @surfcamps = Surfcamp.all.where.not(latitude: nil, longitude: nil)
    else
      @surfcamps = Surfcamp.where("price_per_night_per_person <= ?", params[:maxprice]).distinct
    end

    @hash = Gmaps4rails.build_markers(@surfcamps) do |surfcamp, marker|
      marker.lat surfcamp.latitude
      marker.lng surfcamp.longitude
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end
  end

  def show
    @booking = Booking.new
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end

  def set_params
    params.require(:surfcamp).permit(:name, :description, :rating, :address, :photo)
  end

  def percentage_of_savings(surfcamp)
    discounted_price = surfcamp.discounts.first.discounted_price
    original_price = surfcamp.price_per_night_per_person
    percentage_of_saving = 1 - (discounted_price).fdiv(original_price)
    # multiply by 100 and round it for display
    (percentage_of_saving * 100).round
  end

  helper_method :percentage_of_savings
end
