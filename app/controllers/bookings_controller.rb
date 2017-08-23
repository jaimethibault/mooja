class BookingsController < ApplicationController
  def create
    @booking = Booking.new(set_params)
    @booking.surfcamp_id = params[:surfcamp_id]
    @booking.save
    #redirect to modify
    redirect_to surfcamps_path
  end

  private

  def set_params
    params.require(:booking).permit(:starts_at, :ends_at, :status, :user_id, :surfcamp_id)
  end
end
