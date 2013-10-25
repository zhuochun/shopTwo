class FileReader
  # Type of files supported
  INVENTORY, SETTLEMENT, STOCK = %w(inventory settlement stock)

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
  #
  # OPTIMIZE change this to raw SQL
  def process_inventory(file)
    File.foreach(file) do |line|
      name, cate, manu, barcode, cost, cur_stock, min_stock, bundle = line.chomp.force_encoding("UTF-8").split(':')

      product = Product.new name: name,
                            barcode: barcode,
                            cost_price: cost,
                            current_stock: cur_stock,
                            minimum_stock: min_stock,
                            bundle_unit: bundle

      product.category = Category.find_or_create_by_name(cate)
      product.manufacturer = Manufacturer.find_or_create_by_name(manu)

      product.save
    end
  end

  # Settlement Format: barcode:quantity:price:date
  # 33995417:2:10:1/9/2013
  def process_settlement(file, store)
    # create a settlement
    settlement = store.settlements.create(total_count: 0, total_price: 0)
    # list of items
    columns  = [:settlement_id, :barcode, :store_id, :quantity, :price, :total_price]
    values   = []
    # products and stocks update
    stocks   = []
    products = []

    File.foreach(file) do |line|
      barcode, quantity, price, date = line.chomp.force_encoding("UTF-8").split(':')
      total_price = quantity.to_i * price.to_f

      settlement.total_count += quantity.to_i
      settlement.total_price += total_price
      settlement.created_at   = date

      values << [settlement.id, barcode, store.id, quantity, price, total_price]
      stocks << "UPDATE stocks SET quantity = quantity - #{quantity} " +
                "WHERE store_id = #{store.id} AND product_id = #{barcode}"
      products << "UPDATE products SET current_stock = current_stock - #{quantity} " +
                  "WHERE id = #{barcode}"
    end

    # import settle items
    SettleItem.import columns, values, validate: false
    # update settle items date
    ActiveRecord::Base.connection().execute("UPDATE settle_items SET created_at = '#{settlement.created_at}' " +
                                            "WHERE settlement_id = #{settlement.id}")

    # update stocks and products
    ActiveRecord::Base.connection().execute(stocks.join(";"))
    ActiveRecord::Base.connection().execute(products.join(";"))

    # save settlement
    settlement.save
  end

  # Stock Format: barcode:quantity:minimum_stock
  # 77797546:7225:1313
  def process_stock(file, store)
    columns = [:product_id, :store_id, :quantity, :minimum]
    values  = []

    File.foreach(file) do |line|
      barcode, quantity, minimum = line.chomp.force_encoding("UTF-8").split(':')

      values << [barcode.to_i, store.id, quantity.to_i, minimum.to_i]
    end

    Stock.import columns, values, validate: false
  end

  private

  def valid_file?
    @file && @file.content_type == "text/plain"
  end

end
