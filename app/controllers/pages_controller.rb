class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @surfcamps = []
    Discount.all.each do |discount|
      @surfcamps << discount.surfcamp
    end
    @surfcamps = @surfcamps.first(6)

  end
end
