require 'json'
require 'open-uri'

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
      marker.infowindow render_to_string(partial: "/surfcamps/map_box", locals: { surfcamp: surfcamp })
      marker.picture({
        "url" => ApplicationController.helpers.asset_path("shaka_empty.png"),
        "width"   => 40,
        "height"  => 40
      })
    end
  end

  def show
    @booking = Booking.new
    @errors = {}
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end

  def set_params
    params.require(:surfcamp).permit(:name, :description, :rating, :address, photos: [])
  end

  def percentage_of_savings(surfcamp)
    discounted_price = surfcamp.discounts.first.discounted_price
    original_price = surfcamp.price_per_night_per_person
    percentage_of_saving = 1 - (discounted_price).fdiv(original_price)
    # multiply by 100 and round it for display
    (percentage_of_saving * 100).round
  end

  def marker_img(surfcamp)
    # ['green', 'red'].sample
    # check si on a des infos météo pour ce surf camp
    unless surfcamp.waves_period.blank?
      # check si la période est inférieure à 10s >> red
      if surfcamp.waves_period >= 10
        return view_context.image_path "shaka-full.png"
      else
        return "https://res.cloudinary.com/dlnmbo3ol/image/upload/v1504170769/shaka-empty_kpz2ok.png"
      end
    else
      return "https://res.cloudinary.com/dlnmbo3ol/image/upload/v1504170769/shaka-empty_kpz2ok.png"
    end
  end

  helper_method :percentage_of_savings
end
