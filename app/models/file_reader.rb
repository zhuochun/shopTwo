class FileReader
  # Type of files supported
  INVENTORY, SETTLEMENT, STOCK, SPENDING = %w(inventory settlement stock spending)

  def initialize(file, type)
    @file = file
    @type = type
  end

  def process(*args)
    if valid_file?
      self.send("process_#{@type}", @file.tempfile, *args)
    else
      false
    end
  end

  def seed(*args)
    self.send("process_#{@type}", @file, *args)
  end

  # Inventory Format: name:category:manufacturer:barcode:cost:cur_stock:min_stock:bundle
  # BHC Golf Visor With Magnetic Marker:Stop Smoking:Kit E Kat:59030623:26.85:3325:2625:0
  def process_inventory(file)
    # products
    product_columns = [:name, :category_id, :manufacturer_id, :id, :cost_price,
                       :current_stock, :minimum_stock, :bundle_unit, :daily_price]
    products = []
    # categories
    categories = {}
    categories_count = 1
    # manufacturers
    manufacturers = {}
    manufacturers_count = 1

    File.foreach(file) do |line|
      product = line.chomp.force_encoding('UTF-8').split(':')

      if categories[product[1]]
        categories[product[1]][:count] += 1
        product[1] = categories[product[1]][:id]
      else
        categories[product[1]] = { id: categories_count, count: 1 }
        product[1] = categories_count
        categories_count += 1
      end

      if manufacturers[product[2]]
        manufacturers[product[2]][:count] += 1
        product[2] = manufacturers[product[2]][:id]
      else
        manufacturers[product[2]] = { id: manufacturers_count, count: 1 }
        product[2] = manufacturers_count
        manufacturers_count += 1
      end

      product[8] = product[4].to_f * 1.3

      products << product
    end

    Product.import product_columns, products, validate: false
    Category.import [:name, :products_count], categories.map { |k, v| [k, v[:count]] }, validate: false
    Manufacturer.import [:name, :products_count], manufacturers.map { |k, v| [k, v[:count]] }, validate: false
  end

  # Settlement Format: barcode:quantity:price:date
  # 33995417:2:10:1/9/2013
  def process_settlement(file, store, options = {})
    # create a settlement
    settlement = store.settlements.create(total_count: 0, total_price: 0)
    # list of items
    columns  = [:settlement_id, :barcode, :store_id, :quantity, :price, :total_price]
    values   = []
    # products and stocks update
    stocks   = []
    products = []

    File.foreach(file) do |line|
      barcode, quantity, price, date = line.chomp.force_encoding('UTF-8').split(':')
      total_price = quantity.to_i * price.to_f

      settlement.total_count += quantity.to_i
      settlement.total_price += total_price
      settlement.created_at   = date

      values << [settlement.id, barcode, store.id, quantity, price, total_price]
      stocks << %(
        UPDATE stocks
        SET quantity = quantity - #{sanitize(quantity)}
        WHERE store_id = #{sanitize(store.id)} AND
              product_id = #{sanitize(barcode)})
      products << %(
        UPDATE products
        SET current_stock = current_stock - #{sanitize(quantity)}
        WHERE id = #{sanitize(barcode)})
    end

    # import settle items
    SettleItem.import columns, values, validate: false
    # update settle items date
    ActiveRecord::Base.connection().execute(%(
      UPDATE settle_items
      SET created_at = #{sanitize(settlement.created_at)}
      WHERE settlement_id = #{sanitize(settlement.id)}))

    # update stocks and products
    unless options[:skip_deduction]
      ActiveRecord::Base.connection().execute(stocks.join(';'))
      ActiveRecord::Base.connection().execute(products.join(';'))
    end

    # save settlement
    settlement.save
  end

  # Stock Format: barcode:quantity:minimum_stock
  # 77797546:7225:1313
  def process_stock(file, store)
    columns = [:product_id, :store_id, :quantity, :minimum]
    values  = []

    File.foreach(file) do |line|
      barcode, quantity, minimum = line.chomp.force_encoding('UTF-8').split(':')

      values << [barcode.to_i, store.id, quantity.to_i, minimum.to_i]
    end

    Stock.import columns, values, validate: false
  end

  # Spending Format: phone:spending:credits_earned:quantity:date
  # 42345670:20.0:2.0:10:1/9/2013
  def process_spending(file, store)
    updates, users, orders = [], {}, []

    File.foreach(file) do |line|
      phone, total, credit, quantity, date = line.chomp.force_encoding('UTF-8').split(':')

      unless quantity == '0'
        updates << %(
          UPDATE users
          SET credits = credits + #{sanitize(credit.to_f)}
          WHERE phone = #{sanitize(phone)})

        orders << [phone, total, credit, quantity, date]
      end
    end

    # update credits
    ActiveRecord::Base.connection().execute(updates.join(';'))

    # process order
    User.where(phone: orders.map { |order| order[0] }.uniq)
        .pluck(:id, :phone).map { |id, phone| users[phone] = id }

    orders.each do |order|
      store.shop_orders.create user_id: users[order[0]],
                               subtotal: order[1],
                               credits: order[2],
                               quantity: order[3],
                               created_at: order[4]
    end
  end

  private

  def valid_file?
    @file && (@file.content_type == 'text/plain' || @file.content_type == "application/octet-stream")
  end

  def sanitize(*args)
    ActiveRecord::Base.sanitize(*args)
  end

end
