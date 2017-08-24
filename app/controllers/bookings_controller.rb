class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :related_surfcamp, :price_paid]

  def show
    @surfcamp = related_surfcamp
  end

  def create
    @booking = Booking.new(set_params)
    @booking.surfcamp_id = params[:surfcamp_id]
    @booking.save
    #redirect to modify
    redirect_to surfcamps_path
  end

  private


  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_params
    params.require(:booking).permit(:starts_at, :ends_at, :status, :user_id, :surfcamp_id)
  end

  def related_surfcamp
    @surfcamp_id = @booking.surfcamp_id
    @surfcamp = Surfcamp.find(@surfcamp_id)
    @surfcamp
  end

  # def price_paid
  #   @price_paid = 0

  #   @booking.occupancies.each do |occupancy|
  #     @price = occupancy.price
  #     @price_paid += @price
  #   end
  #   @price_paid
  # end

  # def original_price
  #   @original_price = 0

  #   @booking.occupancies.each do |occupancy|
  #     @room_id = occupancy.room_id
  #     @room = Room.find(@room_id)
  #     @price_per_night = @room.price_per_night
  #     @original_price += @price_per_night
  #   end
  #   @original_price
  # end

  helper_method :price_paid, :original_price
end
