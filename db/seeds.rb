# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'nokogiri'

puts "Destroying Discounts"
Discount.destroy_all
puts "Destroying Bookings"
Booking.destroy_all
puts "Destroying Surfcamps"
Surfcamp.destroy_all
puts "Destroying Users"
User.destroy_all


puts "Creating Users"
i = 0
users = [
  "thibault@mooja.surf",
  "clemence@mooja.surf",
  "dima@mooja.surf",
  "arthur@mooja.surf"
]
first_names = [
  "Thibault",
  "Clemence",
  "Dima",
  "Arthur"
]

4.times do
  user = User.new
  user.email = users[i]
  user.password = "#{first_names[i]}password"
  user.first_name = first_names[i]
  user.last_name = Faker::Name.last_name
  urls = [
    "https://avatars2.githubusercontent.com/u/28653879?v=4&s=460",
    "https://avatars3.githubusercontent.com/u/28231166?v=4&s=460",
    "https://avatars3.githubusercontent.com/u/29582715?v=4&s=460",
    "https://avatars0.githubusercontent.com/u/26402932?v=4&s=460"
  ]
  user.facebook_picture_url = urls[i]
  user.save!
  i += 1
end
puts "Users created"

puts "Creating Admin"
admin = User.new
admin.email = "admin@admin.admin"
admin.password = "astrongpassword"
admin.first_name = "admin"
admin.last_name = "ADMIN"
admin.facebook_picture_url = "https://avatars2.githubusercontent.com/u/2471555?v=4&s=460"
admin.admin = true
admin.save!
puts "Admin created"

puts "Creating Surfcamps"
# all the countries available on the website
# If you are in development and do not want to scrapp all the crountries,
# just comment the countries that are'nt necessary.
# After seed uncomment, that way whe can have the proper seed on master
# countries = [
#   "portugal",
#   "morocco",
#   "canary-islands",
#   "costa-rica",
#   "indonesia",
#   "barbados",
#   "spain",
#   "france",
#   "ireland",
#   "sri-lanka",
#   "dominican-republic",
#   "mexico",
#   "australia",
#   "el-salvador",
#   "peru",
#   "south-africa",
#   "nicaragua",
#   "philippines",
#   "brazil",
#   "new-zealand",
#   "india",
#   "maldives"
#   ]
countries_data = [
  { country: "portugal", city: "Lisbon", airport_code: "LIS" },
  { country: "morocco", city: "Agadir", airport_code: "AGA" },
  { country: "canary-islands", city: "Canary Islands", airport_code: "LPA" },
  { country: "costa-rica", city: "San Jose", airport_code: "SYQ" },
  { country: "indonesia", city: "Jakarta", airport_code: "CGK" },
  { country: "barbados", city: "Bridgetown", airport_code: "BGI" },
  { country: "spain", city: "Bilbao", airport_code: "BIO" },
  { country: "france", city: "Paris", airport_code: "PAR" },
  { country: "ireland", city: "Dublin", airport_code: "DUB" },
  { country: "sri-lanka", city: "Colombo", airport_code: "CMB" },
  { country: "dominican-republic", city: "Saint-Domingue", airport_code: "SDQ" },
  { country: "mexico", city: "Mexico City", airport_code: "MEX" },
  { country: "el-salvador", city: "San Salvador", airport_code: "ZSA" },
  { country: "peru", city: "Lima", airport_code: "LIM" },
  { country: "south-africa", city: "Pretoria", airport_code: "HPR" },
  { country: "nicaragua", city: "Managua", airport_code: "MGA" },
  { country: "philippines", city: "Manila", airport_code: "MNL" },
  { country: "brazil", city: "Rio De Janeiro", airport_code: "GIG" },
  { country: "new-zealand", city: "Wellington", airport_code: "WLG" },
  { country: "india", city: "New Delhi", airport_code: "DEL" },
  { country: "maldives", city: "Malé", airport_code: "MLE" }
]


# Showcasing the countries we will scrapp
puts ""
puts "    This is all the countries we will scrapp"
countries_data.each_with_index do |data, index|

  puts "    #{index +1} - #{data[:country]}"
end
puts ""
# iterating over all the countries
countries_data.each do |data|
  s = 0
  puts "    Iterating over #{data[:country]}"
  # The url we are scrapping
  url = "https://www.surfholidays.com/property-search?country=#{data[:country]}&town=all&checkin=&checkout=&guests=2&suitable_for=surfcamps"
  base_url = "https://www.surfholidays.com"
  html_file = open(url).read
  html_doc = Nokogiri::HTML(html_file)
  surfcamp_total = html_doc.search(".name-location a").count
  # We look for all the a in the div that match our criterias
  puts "    #{surfcamp_total} Surfcamps to magically scrapp in #{data[:country]}"
  html_doc.search(".name-location a").each do |element|
    page_url = element.attribute('href').value
    complete_url = "#{base_url}#{page_url}"

    html_file = open(complete_url).read
    html_doc = Nokogiri::HTML(html_file)
    images_surfcamp = []

    # Initializing instance of surfcamp
    surfcamp = Surfcamp.new

    # We create surfcamp with the data that has been scrapped
    html_doc.search("#custom-slider ul li").take(5).each do |element|
      images_surfcamp << element['style'][/url\((.+)\)/, 1].gsub("'","")
    end
    # creating surfcamp image
    surfcamp.photo_urls = images_surfcamp
    html_doc.search("h1.sh-navy").each do |element|
      name = element.text
      # creating surfcamp name
      surfcamp.name = name
    end
    # creating surfcamp description
    elements = []
    html_doc.search(".mt30 p.mt15").each do |element|
      elements << element.text.delete("\r").delete("\n")
    end
    surfcamp.description = elements[0]

     html_doc.search("#accom-detail-location").each do |element|
      address = element.text.strip
      # creating surfcamp address
      surfcamp.address = address
    end
    # creating surfcamp country
    surfcamp.country = data[:country]

    # creating Surfcamp city
    surfcamp.city = data[:city]

    # creating Surfcamp airport_code
    surfcamp.airport_code = data[:airport_code]

    ratings = []
    html_doc.search("p.bolder.sh-orange span.bigger-font18").each do |element|
      ratings << element.text.strip
      # creating surfcamp rating
      surfcamp.rating = ratings[0]
    end
    # creating surfcamp capacity
    surfcamp.capacity = rand(6..50)
    # creating surfcamp price_per_night_per_person
    surfcamp.price_per_night_per_person = rand(30..70)
    surfcamp.save!

    # getting today's weather forecast for each surfcamp
    # checking if surfcamp address was geocoded correctly
    unless surfcamp.latitude.blank?
      url = "http://api.worldweatheronline.com/premium/v1/marine.ashx?key=#{ENV['WEATHER_API']}&format=json&q=#{surfcamp.latitude},#{surfcamp.longitude}"
      weather_serialized = open(url).read
      weather = JSON.parse(weather_serialized)
      # getting weather data for today at noon
      waves_period = weather['data']['weather'].first['hourly'][4]['swellPeriod_secs']
      water_temp = weather['data']['weather'].first['hourly'][4]['waterTemp_C']
      air_temp = weather['data']['weather'].first['hourly'][4]['tempC']
      weather_desc = weather['data']['weather'].first['hourly'][4]['weatherDesc'][0]['value']

      hash = {waves_period: waves_period, water_temp: water_temp, air_temp: air_temp, weather_desc: weather_desc}
      surfcamp.update(hash)
    end
    s += 1
    puts "    #{s}/#{surfcamp_total} scrapped in #{data[:country]}"
  end
  puts ""
end
puts "Done creating surfcamps"


puts "Creating Discounted Prices"
sept_first = Date.parse("September 1st")

# creating 0 or 1 promo per surfcamp
Surfcamp.all.each do |surfcamp|

  # creating discount with a proba of 80%
  discount_occurence_probability = 80
  apply_discount = (1..100).to_a.sample > (100 - discount_occurence_probability)

  if apply_discount
    discount = Discount.new
    # creating discount between 20 and 50% reduction
    discount_rate = [20, 30, 40, 50].sample.to_f/100
    discounted_price = (1 - discount_rate) * surfcamp.price_per_night_per_person
    discount.discounted_price = discounted_price

    # Between September 1st and September 15th
    discount.limit_offer_date = (sept_first..(sept_first + 15.days)).to_a.sample

    discount.discount_starts_at = (sept_first..(sept_first + 15)).to_a.sample
    discount.discount_ends_at = discount.discount_starts_at + (7..28).to_a.sample.days

    discount.surfcamp_id = surfcamp.id
    discount.save!
  end
end

puts "Done Creating Discounted Prices"


puts "Creating Bookings"

surfcamps = Surfcamp.all
surfcamps.each do |surfcamp|
  # creating between 2 and 10 bookings per surfcamp
  rand(2..10).times do
    # initializing instance of Booking
    booking = Booking.new
    sept_first = Date.parse("September 1st")
    # creating starts at and ends at and status and foreign keys
    booking.starts_at = sept_first + rand(3..14).days
    booking.ends_at = booking.starts_at + rand(3..14).days
    booking.status = "paid"
    booking.surfcamp_id = surfcamp.id
    users = User.all
    user = users.sample
    booking.user_id = user.id
    # creating pax_nb
    booking.pax_nb = rand(1..4)
    # creating total original price
    booking_duration = (booking.ends_at - booking.starts_at)/86400
    booking.total_original_price = booking.pax_nb * surfcamp.price_per_night_per_person * booking_duration

    # creating total discounted price
    # is there a discount for this surfcamp
    surfcamp.discounts.first.blank? ? discount = nil : discount = surfcamp.discounts.first

    # Build array of nights
    nights = []
    night = booking.starts_at.to_date
    booking_duration.to_i.times do |_n|
      nights << night
      night += 1
    end

    total_discounted_price = 0
    # check if surfcamp has a discount
    if discount.nil?
      total_discounted_price = booking.total_original_price
    else
      # for each night
      nights.each do |night|
        # check for each night if a discount is applicable
        if night >= discount.discount_starts_at.to_date && night <= discount.discount_ends_at.to_date
          # then apply the discount for this night
          night_price = discount.discounted_price * booking.pax_nb
        else
          # otherwise normal price for this night
          night_price = surfcamp.price_per_night_per_person * booking.pax_nb
        end
        # sum each price per night with discount
        total_discounted_price += night_price
      end
    end

    booking.total_discounted_price = total_discounted_price

    booking.save!
    # puts "successfully saved a booking for #{surfcamp.name}"
  end
end

puts "Done Creating Bookings"

puts "Seed is done"
puts "Happy coding!!!"


