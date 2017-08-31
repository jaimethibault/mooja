require "rest-client"

class PaymentsController < ApplicationController
  before_action :set_booking

  def new
  end

  def create
    customer = Stripe::Customer.create(
    source: params[:stripeToken],
    email:  params[:stripeEmail]
  )

  charge = Stripe::Charge.create(
    customer:     customer.id,   # You should store this customer id and re-use it.
    amount:       (@booking.total_discounted_price * 100).to_i, # or amount_cents or amount_pennies
    description:  "Payment for a stay at #{@booking.surfcamp.name} from #{@booking.starts_at.strftime("%d/%m/%Y")} to #{@booking.ends_at.strftime("%d/%m/%Y")}",
    currency:     "EUR"
  )

  @booking.update(status: 'paid') # include in the bracket payment: charge.to_json after adding a new column in Booking
  redirect_to booking_payment_thanks_path(@booking)

rescue Stripe::CardError => e
  flash[:alert] = e.message
  redirect_to new_booking_payment_path(@booking)
  end

  def thanks
    @surfcamp = @booking.surfcamp
    date_departure = "#{@booking.starts_at.strftime("%Y")}-#{@booking.starts_at.strftime("%m")}-#{@booking.starts_at.strftime("%d")}"
    date_return = "#{@booking.ends_at.strftime("%Y")}-#{@booking.ends_at.strftime("%m")}-#{@booking.ends_at.strftime("%d")}"
    # checking if the user selected a departure city
    if @departure_city = params[:inlineRadioOptions]
      # creating the request for departure
      # need to get these infos from params from the form on the booking confirmation page
      origin = @departure_city
      destination = "LIS"
      date = date_departure # need to add return then
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
        flight_hash["flight_duration"] = Time.at(flight["slice"].first["duration"]*60).utc.strftime("%-Hh%M")
        flight_hash["flight_arrival_time"] = flight["slice"].first["segment"].first["leg"].first["arrivalTime"][11..15]
        flight_hash["flight_arrival_airport"] = flight["slice"].first["segment"].first["leg"].first["destination"]
        flight_hash["flight_price"] = flight["saleTotal"]
        @flights << flight_hash
      end

      # creating the request for return
      # need to get these infos from params from the form on the booking confirmation page
      origin = "LIS"
      destination = @departure_city
      date = date_return # need to add return then
      max_stops = 0 # if direct
      adultCount = 1
      nb_results = 3

      request_return = {
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
      response_return = RestClient.post("https://www.googleapis.com/qpxExpress/v1/trips/search?key=#{ENV['GOOGLE_FLIGHT_API_KEY']}", request_return.to_json, :content_type => :json)
      parsed_resp_return = JSON.parse(response_return)

      # using the response to display flight info
      # getting the flights date
      @flight_date_return = parsed_resp_return["trips"]["tripOption"].first["slice"].first["segment"].first["leg"].first["departureTime"][0..9]

      # building an array of flight hashes to pass to the view
      @flights_return = []
      parsed_resp_return["trips"]["tripOption"].each do |flight|
        flight_hash = {}
        flight_hash["flight_number"] = flight["slice"].first["segment"].first["flight"]["carrier"] + flight["slice"].first["segment"].first["flight"]["number"]
        flight_hash["flight_departure_time"] = flight["slice"].first["segment"].first["leg"].first["departureTime"][11..15]
        flight_hash["flight_departure_airport"] = flight["slice"].first["segment"].first["leg"].first["origin"]
        flight_hash["flight_duration"] = Time.at(flight["slice"].first["duration"]*60).utc.strftime("%-Hh%M")
        flight_hash["flight_arrival_time"] = flight["slice"].first["segment"].first["leg"].first["arrivalTime"][11..15]
        flight_hash["flight_arrival_airport"] = flight["slice"].first["segment"].first["leg"].first["destination"]
        flight_hash["flight_price"] = flight["saleTotal"]
        @flights_return << flight_hash
      end
    end
  end

private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end
end
