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
puts "Destroying Surfcamps"
Surfcamp.destroy_all
puts "Destroying Discounts"
Discount.destroy_all
puts "Destroying Users"
User.destroy_all
puts "Destroying Rooms"
Room.destroy_all
puts "Destroying Occupancies"
Occupancy.destroy_all

puts "Creating Users"
i = 0
users = [
  "jackie@michel.com",
  "michel@jackie.com",
  "micheline@jackie.com"
]
# first_names = [
#   "Jackie",
#   "Michel",
#   "Micheline"
# ]


3.times do
  user = User.new
  user.email = users[i]
  user.password = 'password'

  # user.first_name = first_names[i]
  # user.last_name = Faker::Name.last_name
  # urls = [
  #   "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/10997490_907097779334969_1284262528561985815_n.jpg?oh=c3afa5c308ce7405d109656dda4ffd50&oe=5A2F762F",
  #   "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/20799136_274376209715766_7099253975910970765_n.jpg?oh=e84997278e80801d94f81ca917120c19&oe=5A1A935E",
  #   "https://scontent-cdt1-1.xx.fbcdn.net/v/t1.0-9/19875558_10155671439642176_1610883172945385131_n.jpg?oh=482cbb47e3786e5c1c813330c294645e&oe=5A16D6B7"
  # ]
  # user.facebook_picture_url = urls[i]
  user.save!
  i += 1
end
puts "Users created"

puts "Creating Surfcamps"
url = "https://www.surfholidays.com/property-search?country=all&town=all&checkin=&checkout=&guests=2&suitable_for=0"
base_url = "https://www.surfholidays.com"
html_file = open(url).read
html_doc = Nokogiri::HTML(html_file)
html_doc.search(".name-location a").each do |element|
  page_url = element.attribute('href').value
  complete_url = "#{base_url}#{page_url}"

  html_file = open(complete_url).read
  html_doc = Nokogiri::HTML(html_file)
  images_surfcamp = []
  surfcamp = Surfcamp.new
  html_doc.search("#custom-slider ul li").each do |element|
    images_surfcamp << element['style'][/url\((.+)\)/, 1]
  end
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
end
puts "Done creating surfcamps"













