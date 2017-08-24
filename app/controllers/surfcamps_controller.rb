class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_surfcamp, only: [:show]

  def index
    if params[:maxprice].blank? && params[:address].blank?
      @surfcamps = Surfcamp.all.where.not(latitude: nil, longitude: nil)
    else
      # @surfcamps = Surfcamp.where("price_per_night_per_person <= ?", params[:maxprice]).or(Surfcamp.near(params[:address], 500))
      @surfcamps_location = Surfcamp.near(params[:address], 500)
      if params[:maxprice].blank?
        @surfcamps = @surfcamps_location
      elsif params[:address].blank?
        @discounted_surfcamps = Surfcamp.joins(:discounts).where("discounted_price <= ?", params[:maxprice])
        @normal_price_surfcamps = Surfcamp.where("price_per_night_per_person <= ?", params[:maxprice])
        @matching_surfcamps = @discounted_surfcamps + @normal_price_surfcamps
        @surfcamps = @matching_surfcamps.uniq
      else
        @discounted_surfcamps = @surfcamps_location.joins(:discounts).where("discounted_price <= ?", params[:maxprice])
        @normal_price_surfcamps = @surfcamps_location.where("price_per_night_per_person <= ?", params[:maxprice])
        @matching_surfcamps = @discounted_surfcamps + @normal_price_surfcamps
        @surfcamps = @matching_surfcamps.uniq
      end
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

  helper_method :cheapest_room_without_discount, :cheapest_room_price
end
