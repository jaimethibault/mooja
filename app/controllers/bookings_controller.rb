class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :related_surfcamp, :price_paid]

  def show
    @surfcamp = related_surfcamp
  end

  private

  def related_surfcamp
    @surfcamp_id = @booking.surfcamp_id
    @surfcamp = Surfcamp.find(@surfcamp_id)
    @surfcamp
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def price_paid
    @price_paid = 0

    @booking.occupancies.each do |occupancy|
      @price = occupancy.price
      @price_paid += @price
    end
    @price_paid
  end

  def original_price
    @original_price = 0

    @booking.occupancies.each do |occupancy|
      @room_id = occupancy.room_id
      @room = Room.find(@room_id)
      @price_per_night = @room.price_per_night
      @original_price += @price_per_night
    end
    @original_price
  end

  helper_method :price_paid, :original_price
end
