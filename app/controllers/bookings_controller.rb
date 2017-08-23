class BookingsController < ApplicationController
  def create
    @booking = Booking.new(set_params)
    @booking.surfcamp_id = params[:surfcamp_id]
    @booking.save
    # create occupancy for dorm for this booking
    # TODO: iterate on array of params of room_id & pax
      @occupancy = Occupancy.new(set_occupancy_params)
      @occupancy.booking_id = @booking.id
      room = Room.find(@occupancy.room_id)
      nb_days = (@booking.ends_at - @booking.starts_at)/86400
      # discount for room
      room.discounts.first.blank? ? discount = nil : discount = room.discounts.first

      # Build array of nights
      nights = []
      night = @booking.starts_at.to_date
      nb_days.to_i.times do |_n|
        nights << night
        night += 1
      end
      # for each night
      total_price = 0
      nights.each do |night|
        # check if night has a discount
        if discount.blank?
          total_price = room.price_per_night * nb_days
        else
          # if night has a discount check if nights are inside the discount dates
          if night >= room.discounts.first.discount_starts_at && night <= room.discounts.first.discount_ends_at
            night_price = @room.price_per_night
          else
            # price per night with the discount
            night_price = discount.discounted_price
          end
          # sum each price per night with discount
          total_price += night_price
        end
      end

      price = @occupancy.pax_nb * total_price

      @occupancy.price = price
      @occupancy.save!
    # end of iteration on params of room_id

    # redirect to modify
    redirect_to surfcamps_path
  end

  private

  def set_params
    params.require(:booking).permit(:starts_at, :ends_at, :status, :user_id, :surfcamp_id)
  end

  def set_occupancy_params
    params.require(:occupancy).permit(:pax_nb, :room_id)
  end
end
