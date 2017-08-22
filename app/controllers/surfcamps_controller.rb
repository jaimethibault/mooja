class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @surfcamps = Surfcamp.all
  end

  def surfcamp_params
    params.require(:surfcamp).permit(:name, :description, :photo)
  end
end
