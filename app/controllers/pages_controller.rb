class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]


  def home
    @surfcamps = []
    Discount.all.each do |discount|
      @surfcamps << discount.surfcamp
    end
    @surfcamps = @surfcamps.first(8)

  end

  private

  def percentage_of_savings(surfcamp)
    discounted_price = surfcamp.discounts.first.discounted_price
    original_price = surfcamp.price_per_night_per_person
    percentage_of_saving = 1 - (discounted_price).fdiv(original_price)
    # multiply by 100 and round it for display
    (percentage_of_saving * 100).round
  end
  helper_method :percentage_of_savings
end
