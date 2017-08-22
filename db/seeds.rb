# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'open-uri'
require 'nokogiri'

puts "Destroying Bookings"
Booking.destroy_all
puts "Destroying Rooms"
Room.destroy_all
puts "Destroying Surfcamps"
Surfcamp.destroy_all
puts "Destroying Discounts"
Discount.destroy_all
puts "Destroying Users"
User.destroy_all
puts "Destroying Occupancies"
Occupancy.destroy_all

puts "Creating Users"
i = 0
users = [
  "jackie@michel.com",
  "michel@jackie.com",
  "micheline@jackie.com"
]
first_names = [
  "Thibault",
  "Clemence",
  "Dima"
]

3.times do
  user = User.new
  user.email = users[i]
  user.password = 'password'
  user.first_name = first_names[i]
  user.last_name = Faker::Name.last_name
  urls = [
    "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/10997490_907097779334969_1284262528561985815_n.jpg?oh=c3afa5c308ce7405d109656dda4ffd50&oe=5A2F762F",
    "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/20799136_274376209715766_7099253975910970765_n.jpg?oh=e84997278e80801d94f81ca917120c19&oe=5A1A935E",
    "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/19875558_10155671439642176_1610883172945385131_n.jpg?oh=482cbb47e3786e5c1c813330c294645e&oe=5A16D6B7"
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
admin.facebook_picture_url = "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/10997490_907097779334969_1284262528561985815_n.jpg?oh=c3afa5c308ce7405d109656dda4ffd50&oe=5A2F762F"
admin.admin = true
admin.save!
puts "Admin created"

puts "Creating Surfcamps"
s = 0
# The url we are scrapping
url = "https://www.surfholidays.com/property-search?country=all&town=all&checkin=&checkout=&guests=2&suitable_for=surfcamps"
base_url = "https://www.surfholidays.com"
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)
surfcamp_total = html_doc.search(".name-location a").count
# We look for all the a in the div that match our criterias
html_doc.search(".name-location a").each do |element|
  page_url = element.attribute('href').value
  complete_url = "#{base_url}#{page_url}"

  html_file = open(complete_url).read
  html_doc = Nokogiri::HTML(html_file)
  images_surfcamp = []
  surfcamp = Surfcamp.new

  # We create surfcamp with the data that has been scrapped
  html_doc.search("#custom-slider ul li").each do |element|
    images_surfcamp << element['style'][/url\((.+)\)/, 1].gsub("'","")
  end
  # ajout de la première image du surfcamp au surfcamp
  surfcamp.photo_url = images_surfcamp[0]
  html_doc.search("h1.sh-navy").each do |element|
    name = element.text
    surfcamp.name = name
  end

  surfcamp.description = Faker::Lorem.paragraph

   html_doc.search("#accom-detail-location").each do |element|
    address = element.text.strip
    surfcamp.address = address
  end
  ratings = []
  html_doc.search("p.bolder.sh-orange span.bigger-font18").each do |element|
    ratings << element.text.strip
    surfcamp.rating = ratings[0]
  end

  surfcamp.save!
  s += 1
  puts "#{s}/#{surfcamp_total} created"
end
puts "Done creating surfcamps"

puts "Creating Random Rooms"

surfcamps = Surfcamp.all
surfcamps.each do |surfcamp|
  rand(2..10).times do
      room = Room.new
      room.category = ['dormitory', 'single bedroom', 'twin bedroom'].sample
      if room.category == 'dormitory'
        room.capacity = rand(1..8)
        room.price_per_night = rand(50..70)
      elsif room.category == 'twin bedroom'
        room.capacity = 2
        room.price_per_night = rand(70..99)
      else
        room.capacity = 1
        room.price_per_night = rand(100..120)
      end
    room.surfcamp_id = surfcamp.id
    room.save!
  end
end

puts "Done Creating Rooms"


puts "Creating Discounted Prices"
sept_first = Date.parse("September 1st")

Room.all.each do |room|

  discount_occurence_probability = 30
  apply_discount = (1..100).to_a.sample > (100 - discount_occurence_probability)

  if apply_discount
    discount = Discount.new
    discount_rate = [10, 20, 30, 40, 50, 60, 70].sample.to_f/100
    discount.discounted_price = discount_rate * room.price_per_night

    #Between September 1st and September 15th
    discount.limit_offer_date = (sept_first..(sept_first + 15.days)).to_a.sample

    discount.discount_starts_at = (sept_first..(sept_first + 2.months)).to_a.sample
    discount.discount_ends_at = discount.discount_starts_at + (3..15).to_a.sample.days

    discount.room_id = room.id
    discount.save!
  end
end



puts "Done Creating Discounted Prices"



puts "Seed is done"
puts "Happy coding!!!"

# puts "Creating Occupancies"
# #Je recupere tous les surfcamps
# #Dans les surfcamps je recupere les rooms
# #J'établis un nombre de personnes random
# #

# puts "Done Creating Occupancies"







