require "json"
require "rest-client"


class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :related_surfcamp, :price_paid]


  def show
    @surfcamp = related_surfcamp

    # creating the request
    # need to get these infos from params from the form on the booking confirmation page
    origin = "PAR"
    destination = "AGA"
    date = "2017-09-14" # need to add return then
    max_stops = 0 # if direct
    adultCount = 1
    nb_results = 3

    request = {
      request: {
        slice: [
          {
            origin: origin,
            destination: destination,
            date: date,
            maxStops: max_stops
          }
        ],
        passengers: {
          adultCount: adultCount
        },
        solutions: nb_results
      }
    }

    # sending the request and receiving the answer
    response = RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV['GOOGLE_FLIGHT_API_KEY']}", request.to_json, :content_type => :json)
    parsed_resp = JSON.parse(response)

    # using the response to display flight info
    # getting the flights date
    @flight_date = parsed_resp["trips"]["tripOption"].first["slice"].first["segment"].first["leg"].first["departureTime"][0..9]

    # building an array of flight hashes to pass to the view
    @flights = []
    parsed_resp["trips"]["tripOption"].each do |flight|
      flight_hash = {}
      flight_hash["flight_number"] = flight["slice"].first["segment"].first["flight"]["carrier"] + flight["slice"].first["segment"].first["flight"]["number"]
      flight_hash["flight_departure_time"] = flight["slice"].first["segment"].first["leg"].first["departureTime"][11..15]
      flight_hash["flight_departure_airport"] = flight["slice"].first["segment"].first["leg"].first["origin"]
      flight_hash["flight_duration"] = Time.at(flight["slice"].first["duration"]*60).utc.strftime("%Hh%Mmin")
      flight_hash["flight_arrival_time"] = flight["slice"].first["segment"].first["leg"].first["arrivalTime"][11..15]
      flight_hash["flight_arrival_airport"] = flight["slice"].first["segment"].first["leg"].first["destination"]
      flight_hash["flight_price"] = flight["saleTotal"]
      @flights << flight_hash
    end
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


