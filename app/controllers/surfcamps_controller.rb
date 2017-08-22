class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_surfcamp, only: [:show]

  def index
    if params[:maxprice].nil?
      @surfcamps = Surfcamp.all
    else
      @surfcamps = Surfcamp.joins(:rooms).where("price_per_night < ?", params[:maxprice]).distinct
    end
  end

  def surfcamp_params
    params.require(:surfcamp).permit(:name, :description, :photo)
  end

  def show
  end

  def new
    @surfcamp = Surfcamp.new
  end

  def create
    @surfcamp = Surfcamp.new(set_params)
     if @surfcamp
      redirect_to surfcamps_path(@surfcamp)
    else
      render :new
    end
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end

  def set_params
    params.require(:surfcamp).permit(:name, :description, :rating, :address, :photo)
  end

end
