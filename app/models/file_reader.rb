class FileReader
  # Type of files supported
  INVENTORY, SETTLEMENT = %i(inventory settlement)

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
    File.foreach(file) do |line|
      name, cate, manu, barcode, cost, cur_stock, min_stock, bundle = line.chomp.split(':')

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
    settlement = store.settlements.new

    File.foreach(file) do |line|
      barcode, quantity, price, date = line.chomp.split(':')

      item = SettleItem.new barcode: barcode,
                            quantity: quantity,
                            price: price,
                            created_at: date
      item.total_price = item.quantity * item.price

      settlement.settle_items << item
      settlement.total_count += item.quantity
      settlement.total_price += item.total_price
    end

    settlement.save
  end

  private

  def valid_file?
    @file && @file.content_type == "text/plain"
  end

end
