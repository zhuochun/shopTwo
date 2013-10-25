# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

root = Rails.root
env = Rails.env

puts "Mode: [#{env}] #{root}"

# create stores
puts "=== Stores ==="

Store.destroy_all

grant = Store.create(
  { name: 'Grand Stand',
    size: 1000,
    address: "200 Turf Club Road #01-01\nSingapore 289631",
    geo_latitude: 1.337320,
    geo_longitude: 103.793182,
    contact: 64622102,
    closed: false,
    operation_hours: '9:00 AM - 10:00 PM' })

vivo = Store.create(
  { name: 'Vivo City',
    size: 400,
    address: "1 HarbourFront Walk #B1-23 / #01-23\nSingapore 098585",
    geo_latitude: 1.264150,
    geo_longitude: 103.820847,
    contact: 62751638,
    closed: false,
    operation_hours: '10:00 AM - 10:00 PM' })

changi = Store.create(
  { name: 'Changi',
    size: 250,
    address: "60, Airport Boulevard, #B16-029, Basement Level South Terminal 2\nSINGAPORE 819643",
    geo_latitude: 1.351440,
    geo_longitude: 103.986267,
    contact: 65431147,
    closed: false,
    operation_hours: '07:00 AM- 11:00 PM' })

clementi = Store.create(
  { name: 'Clementi',
    size: 100,
    address: "Blk 352, Clementi Ave 2, #01-141/143\nSINGAPORE 120352",
    geo_latitude: 1.314780,
    geo_longitude: 103.771362,
    contact: 67745642,
    closed: false,
    operation_hours: '24 Hours' })

orchard = Store.create(
  { name: 'Orchard',
    size: 50,
    address: "491, River Valley Road, #01-14, Valley Point\nSINGAPORE 248371",
    geo_latitude: 1.293170,
    geo_longitude: 103.826828,
    contact: 67339861,
    closed: false,
    operation_hours: '08:00 AM- 10:00 PM' })

puts "=== #{Store.count} stores created ==="

# create users
puts "=== Users ==="

User.destroy_all

User.create([
  { username: 'John',
    phone: 12345678,
    birthday: '21-10-2013',
    credits: 100.0,
    role: User::ADMIN,
    email: 'admin@cg3002.ceg',
    password: '12345678' },
  { username: 'Peter',
    phone: 22345678,
    birthday: '21-10-2013',
    credits: 100.0,
    role: User::MANAGER,
    email: 'peter@cg3002.ceg',
    password: '12345678',
    store: grant },
  { username: 'Jason',
    phone: 32345678,
    birthday: '21-10-2013',
    credits: 100.0,
    role: User::MANAGER,
    email: 'jason@cg3002.ceg',
    password: '12345678',
    store: vivo },
  { username: 'Haskell',
    phone: 33345678,
    birthday: '21-10-2013',
    credits: 100.0,
    role: User::MANAGER,
    email: 'haskell@cg3002.ceg',
    password: '12345678',
    store: changi },
  { username: 'Ruby',
    phone: 34345678,
    birthday: '21-10-2013',
    credits: 100.0,
    role: User::MANAGER,
    email: 'ruby@cg3002.ceg',
    password: '12345678',
    store: clementi },
  { username: 'JavaScript',
    phone: 35345678,
    birthday: '21-10-2013',
    credits: 100.0,
    role: User::MANAGER,
    email: 'javascript@cg3002.ceg',
    password: '12345678',
    store: orchard },
  { username: 'David',
    phone: 42345678,
    birthday: '21-10-2013',
    credits: 800.0,
    role: User::CUSTOMER,
    email: 'david@cg3002.ceg',
    password: '12345678'},
])

puts "=== #{User.count} users created ==="

# populate inventory
file = "#{root}/db/inventory/#{env}.txt"

puts "=== Inventory ==="
puts "FILE: #{file}"

Product.destroy_all
Category.destroy_all
Manufacturer.destroy_all

reader = FileReader.new(file, FileReader::INVENTORY)
reader.seed

puts "=== #{Product.count} products created ==="
puts "=== #{Category.count} categories created ==="
puts "=== #{Manufacturer.count} manufacturers created ==="
