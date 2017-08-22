class SurfcampsController < ApplicationController
  def index
    @surfcamps = Surfcamp.all
  end

  def surfcamp_params
    params.require(:surfcamp).permit(:name, :description, :photo)
  end
end
