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
  #
  # OPTIMIZE change this to raw SQL
  def process_settlement(file, store)
    settlement = store.settlements.new

    File.foreach(file) do |line|
      barcode, quantity, price, date = line.chomp.force_encoding("UTF-8").split(':')

      item = SettleItem.new barcode: barcode,
                            store_id: store.id,
                            quantity: quantity,
                            price: price,
                            created_at: date
      item.total_price = item.quantity * item.price

      settlement.settle_items << item
      settlement.total_count  += item.quantity
      settlement.total_price  += item.total_price
      settlement.created_at    = date
    end

    settlement.save
  end

  # Stock Format: barcode:quantity:minimum_stock
  # 77797546:7225:1313
  #
  # OPTIMIZE raw SQL
  def process_stock(file, store)
    stocks = []

    File.foreach(file) do |line|
      barcode, quantity, minimum = line.chomp.force_encoding("UTF-8").split(':')

      stocks << { product_id: barcode,
                  store_id: store.id,
                  quantity: quantity,
                  minimum: minimum }
    end

    Stock.transaction { Stock.create(stocks) }
  end

  private

  def valid_file?
    @file && @file.content_type == "text/plain"
  end

end
