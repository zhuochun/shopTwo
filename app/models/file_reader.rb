class FileReader
  # Type of files supported
  TYPE = %w(inventory transaction)

  def initialize(file, type)
    @file = file
    @type = type
  end

  def process
    if valid_file?
      self.send("process_#{@type}")
    else
      false
    end
  end

  def process_inventory
    count = 0

    File.foreach(@file.tempfile) do |line|
      name, category, manufacturer, barcode, cost, current_stock, minimum_stock, bundle = line.chomp.split(':')

      product = Product.new name: name.strip,
                            barcode: barcode.to_i,
                            daily_price: cost.to_i,
                            cost_price: cost.to_i,
                            current_stock: current_stock.to_i,
                            minimum_stock: minimum_stock.to_i,
                            bundle_unit: bundle.to_i

      product.category = Category.find_or_create_by_name(category.strip)
      product.manufacturer = Manufacturer.find_or_create_by_name(manufacturer.strip)

      count += product.save ? 1 : 0
    end

    count
  end

  def process_transaction
    count = 0

    File.foreach(@file.tempfile) do |line|

    end

    count
  end

  def valid_file?
    @file.content_type == "text/plain"
  end

end
