class SurfcampsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  before_action :set_surfcamp, only: [:show]

  def show
  end

  private

  def set_surfcamp
    @surfcamp = Surfcamp.find(params[:id])
  end
end
