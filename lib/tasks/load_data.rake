namespace :import do

  # ========================================
  # to populate inventories
  # ========================================

  def inventory_path(env)
    "#{Rails.root}/db/inventory/#{env}.txt"
  end

  desc 'Load sample inventories (in production)'
  task inventory: [:environment] do
    puts "==== Load Inventory (production) to Database ===="

    FileReader.new(inventory_path("production"), FileReader::INVENTORY).seed

    puts "=== #{Product.count} products created ==="
    puts "=== #{Category.count} categories created ==="
    puts "=== #{Manufacturer.count} manufacturers created ==="
    puts "==== Inventory Loaded to Database ===="
  end

  # ========================================
  # to populate stocks
  # ========================================
  def stocks_path(size)
    "#{Rails.root}/db/stocks/#{size}.txt"
  end

  def load_stocks(stores)
    stores.each do |store|
      FileReader.new(stocks_path(store.size), FileReader::STOCK).seed(store)
      puts "=== #{store.stocks.size} stocks created for #{store.name} ==="
    end
  end

  desc 'Load sample stocks into database (in production)'
  task stocks: [:environment] do
    puts "==== Load Stocks (Production) to Database ===="

    stores = Store.all
    puts "=== #{stores.size} stores found in database ==="

    load_stocks(stores)
    puts "==== Stocks Loaded to Database ===="
  end

  # ========================================
  # to populate transactions
  # ========================================
  def transaction_path(size)
    "#{Rails.root}/db/transactions/#{size}/*.txt"
  end

  def load_transactions(stores)
    stores.each do |store|
      Dir[transaction_path(store.size)].each do |file|
        FileReader.new(file, FileReader::SETTLEMENT).seed(store, skip_deduction: true)
        print '.'
      end

      puts "\n=== #{store.settlements.size} transactions created for #{store.name} ==="
    end
  end

  desc 'Load sample transactions into database (in production)'
  task transactions: [:environment] do
    puts "==== Load Transactions (Production) to Database ===="

    stores = Store.all
    puts "=== #{stores.size} stores found in database ==="

    load_transactions(stores)
    puts "==== Transactions Loaded to Database ===="
  end

  # ========================================
  # to populate stocks and transactions in production (demo)
  # ========================================
  desc 'Load inventory, stocks and transactions into database (in production)'
  task prod_demo: [:inventory, :stocks, :transactions]

  # ========================================
  # to populate stocks and transactions in production (test)
  # ========================================
  desc 'Load inventory, and stocks, transactions for one store (in production)'
  task prod_test: [:environment, :inventory] do
    store = Store.find(1)
    puts "=== Store #{store.name} is used for testing ==="

    puts "==== Load Stocks (Production - Test) to Database ===="
    load_stocks([store])
    puts "==== Stocks Loaded to Database ===="

    puts "==== Load Transactions (Production - Test) to Database ===="
    load_transactions([store])
    puts "==== Transactions Loaded to Database ===="
  end

  # ========================================
  # to populate stocks and transactions in development
  # ========================================
  desc 'Load inventory, stocks into database (in development)'
  task dev: [:environment] do
    puts "==== Destroy Inventory and Stocks in Database ===="

    Stock.destroy_all
    Product.destroy_all
    Category.destroy_all
    Manufacturer.destroy_all

    puts "==== Load Inventory (development) to Database ===="

    FileReader.new(inventory_path("development"), FileReader::INVENTORY)
              .seed

    puts "=== #{Product.count} products created ==="
    puts "=== #{Category.count} categories created ==="
    puts "=== #{Manufacturer.count} manufacturers created ==="
    puts "==== Inventory Loaded to Database ===="

    puts "==== Load Stocks (development) to Database ===="

    store = Store.find(1)
    FileReader.new(stocks_path("1000_dev"), FileReader::STOCK)
              .seed(store)

    puts "=== #{store.stocks.size} stocks created for #{store.name} ==="
    puts "==== Stocks Loaded to Database ===="
  end

end
