namespace :import do

  # to populate stocks
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
    puts "==== Load Stocks to Database ===="

    stores = Store.all
    puts "=== #{stores.size} stores found in database ==="

    load_stocks(stores)
    puts "==== Stocks Loaded to Database ===="
  end

  # to populate transactions
  def transaction_path(size)
    "#{Rails.root}/db/transactions/#{size}/*.txt"
  end

  def load_transactions(stores)
    stores.each do |store|
      Dir[transaction_path(store.size)].each do |file|
        FileReader.new(file, FileReader::SETTLEMENT).seed(store, skip_deduction: true)
        print '.'
      end

      puts "=== #{store.settlements.size} transactions created for #{store.name} ==="
    end
  end

  desc 'Load sample transactions into database (in production)'
  task transactions: [:environment] do
    puts "==== Load Transactions to Database ===="

    stores = Store.all
    puts "=== #{stores.size} stores found in database ==="

    load_transactions(stores)
    puts "==== Transactions Loaded to Database ===="
  end
end
