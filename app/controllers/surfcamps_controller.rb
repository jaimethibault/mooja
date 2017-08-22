class SurfcampsController < ApplicationController
  def index
    @surfcamps = Surfcamp.all
  end
end
