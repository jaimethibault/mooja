require 'json'
require 'open-uri'

class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_surfcamp, only: [:show]

  def index
    if params[:maxprice].nil?
      @surfcamps = Surfcamp.all.where.not(latitude: nil, longitude: nil)
    else
      @surfcamps = Surfcamp.joins(:rooms).where("price_per_night < ?", params[:maxprice]).distinct
    end

    @hash = Gmaps4rails.build_markers(@surfcamps) do |surfcamp, marker|
      marker.lat surfcamp.latitude
      marker.lng surfcamp.longitude
      # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    end

    #Parsing Test#
    all_weekly_weathers = []
    @surfcamps.each do |surfcamp|
      url = "http://api.worldweatheronline.com/premium/v1/marine.ashx?key=#{ENV['WEATHER_API']}&format=json&q=#{surfcamp.latitude},#{surfcamp.longitude}"
      weather_serialized = open(url).read
      weather = JSON.parse(weather_serialized)
      weekly_weather_datas = []
      weekly_weather_datas << surfcamp.name
      weather['data']['weather'].each do |element|
        date_weather_data = {}
        date_weather_data[:date] = element['date']
        date_weather_data[:max_temp] = element['maxtempC']
        date_weather_data[:wind_speed] = element['hourly'][4]['windspeedKmph']
        date_weather_data[:weather_description] = element['hourly'][4]['weatherDesc'].first['value']
        date_weather_data[:wave] = element['hourly'][4]['swellPeriod_secs']
        weekly_weather_datas << date_weather_data
      end
      weekly_weather = weekly_weather_datas
      all_weekly_weathers << weekly_weather
    end
    @all_weathers = all_weekly_weathers
  end

  def surfcamp_params
    params.require(:surfcamp).permit(:name, :description, :photo)
  end

  def show
    @booking = Booking.new
    @occupancy = Occupancy.new
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end

  def set_params
    params.require(:surfcamp).permit(:name, :description, :rating, :address, :photo)
  end

end
