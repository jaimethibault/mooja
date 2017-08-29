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
  end

private

  def set_booking
    @booking = Booking.find(params[:booking_id])
  end
end
