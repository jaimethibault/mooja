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

  def cheapest_room_price(surfcamp)
    # récupérer les rooms avec leur price
    rooms = surfcamp.rooms
    # checker s'il y a des discounts sur les rooms / pendant les dates choisies
    discounted_rooms_prices = []
    rooms.each do |room|
      !room.discounts.blank? ? discount = room.discounts.first.discounted_price : discount = 0
      final_room_price = room.price_per_night - discount
      discounted_rooms_prices << final_room_price
    end
    discounted_rooms_prices.sort.first
  end

  # def cheapest_room_without_discount(surfcamp)
  #   surfcamp.rooms.order(price_per_night: :asc).first
  # end

  helper_method :cheapest_room_without_discount, :cheapest_room_price
end
