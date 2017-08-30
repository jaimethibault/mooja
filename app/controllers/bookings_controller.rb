require "json"
require "rest-client"


class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :related_surfcamp, :price_paid]


  def show
    @surfcamp = related_surfcamp
  end

  def create
    @booking = Booking.new(set_params)
    @booking.surfcamp_id = params[:surfcamp_id]
    @surfcamp = related_surfcamp


    if @booking.starts_at.present? && @booking.ends_at.present?
      #Calculate booking period in number of days
      nb_days = (@booking.ends_at - @booking.starts_at).to_i/86400

      #Calculate total price without discount
      total_original_price = nb_days * @booking.pax_nb * @surfcamp.price_per_night_per_person

      #Create an array of nights
      nights = []
      night = @booking.starts_at.to_date
      nb_days.to_i.times do |_n|
        nights << night
        night += 1
      end

      #Check if there is a discount on the surfcamp
      if @surfcamp.discounts.blank?
        total_discounted_price = total_original_price
      else
        total_discounted_price = 0
      #Calculate night per night if there is an active discount
        nights.each do |night|
          #Check if night is inside the discount dates
            if night >= @surfcamp.discounts.first.discount_starts_at.to_date && night <= @surfcamp.discounts.first.discount_ends_at.to_date
              night_price = @surfcamp.discounts.first.discounted_price * @booking.pax_nb
            else
              # price per night with the discount
              night_price = @surfcamp.price_per_night_per_person * @booking.pax_nb
            end
            # sum each price per night with discount
            total_discounted_price += night_price
        end
      end
      @booking.total_discounted_price = total_discounted_price
      @booking.total_original_price = total_original_price
      if @booking.save
        #redirect to booking confirmation page
        redirect_to booking_path(@booking)
      else
        @errors = {
          starts_at: @booking.starts_at.blank? ? "can't be blank" : nil,
          ends_at: @booking.ends_at.blank? ? "can't be blank" : nil
        }
        render 'surfcamps/show'
      end
    else
      @errors = {
        starts_at: @booking.starts_at.blank? ? "can't be blank" : nil,
        ends_at: @booking.ends_at.blank? ? "can't be blank" : nil
      }
      render 'surfcamps/show'
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def set_params
    params.require(:booking).permit(:starts_at, :ends_at, :pax_nb, :status, :user_id)
  end

  def related_surfcamp
    @surfcamp_id = @booking.surfcamp_id
    @surfcamp = Surfcamp.find(@surfcamp_id)
    @surfcamp
  end

end


