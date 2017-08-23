class OccupanciesController < ApplicationController

  def create
    @occupancy = Occupancy.new(set_params)

    @occupancy.booking_id = params[:booking_id]
  end

  private

  def set_params
    params.require(:occupancy).permit(:price, :pax_nb, :booking_id, :room_id)
  end
end
