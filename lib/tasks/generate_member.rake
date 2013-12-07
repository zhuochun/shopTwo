namespace :member do

  def path_to(filename)
    "#{Rails.root}/db/members/#{filename}.txt"
  end

  desc 'Create 200 fake members into Database'
  task join: [:environment] do
    puts "==== Creating 200 fake members in Database ===="
    puts "=== #{User.customers.count} customers in database ==="

    users, phone, domain, pwd = [], 10000000, "cg3002.ceg", "12345678"
    user_columns = [:username, :phone, :email, :encrypted_password]

    File.foreach(path_to("names")) do |line|
      name = line.chomp.force_encoding('UTF-8')
      users << [name, phone, "#{name}@#{domain}", pwd]
      phone += 1
    end

    User.import user_columns, users, validate: false

    puts "=== #{User.customers.count} customers now ==="
    puts "==== Fake members created in Database ===="
  end

  desc 'Buy 10 items for 50 members'
  task shopping: [:environment] do
    puts "==== Fake shopping items in online shops ===="
    puts "=== #{Order.count} orders in database ==="

    # get 10 products' id
    products = Product.new_in_store.pluck(:id).take(10)
    # find the fake users
    users = User.where(encrypted_password: "12345678").pluck(:id).take(50)

    users.each do |user|
      order = Order.new user_id: user,
                        name: "fake",
                        email: "fake@cg3002.ceg",
                        phone: "00000019",
                        address: "NUS\nSingapore",
                        used_credit: 0.0,
                        pay_type: "MasterCard",
                        credit_card: "1234123412341234",
                        created_at: Random.rand(30).day.ago

      # add items
      products.each do |product|
        order.line_items.new product_id: product, quantity: 1
      end

      order.save

      print '.'
    end

    puts "\n=== #{Order.count} orders now ==="
    puts "==== Fake shopping is done in Database ===="
  end

  desc 'Write reviews for items bought'
  task review: [:environment] do
    puts "==== Fake reviewing items in online shops ===="
    puts "=== #{Comment.count} reviews in database ==="

    users = User.where(encrypted_password: "12345678").take(10)
    reviews = []

    # read in fake reviews
    File.foreach(path_to("reviews")) do |line|
      reviews << line.chomp.force_encoding('UTF-8')
    end

    users.each do |user|
      print '!'

      products = user.bought_items.pluck(:product_id)
      # write comments for each product
      products.each do |product|
        user.comments.create product_id: product,
                             rating: Random.rand(1..5),
                             content: reviews.sample,
                             created_at: Random.rand(30).day.ago
        print '.'
      end

      print '\n'
    end

    puts "=== #{Comment.count} reviews now ==="
    puts "==== Fake reviewing is done in Database ===="
  end

  desc 'Join, Shopping, Review together'
  task all: [:join, :shopping, :review]

end
