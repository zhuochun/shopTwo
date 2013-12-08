#!/usr/bin/env ruby
# encoding: utf-8

# ruby convert_to_summary 'inventory_file.txt' 'transaction_file.txt' 'output.txt' '9'

class Inventory

  def initialize(filename)
    puts "Inventory filename: #{filename}"

    @filename = filename
    @products = {}
  end

  def read
    file = File.open(@filename, 'r')

    File.foreach(file) do |line|
      _, _, _, barcode, cost, _, _, _ = line.chomp.split(':')
      @products[barcode] = cost.to_f
    end

    file.close
  end

  def price(barcode)
    if @products[barcode]
      @products[barcode] * (1 + rand(5) / 10)
    else
      0
    end
  end
end

class Converter

  def initialize(inventory, filename, output, month)
    puts "filename: #{filename} -> #{output}"

    @inventory = inventory
    @filename  = filename
    @output    = output
    @month     = month
    @transacts = {}
  end

  def run
    file = File.open(@filename, 'r')

    File.foreach(file) do |line|
      _, _, _, barcode, quantity, date = line.chomp.force_encoding("UTF-8").split ':'

      # replace month
      date = date.gsub(/\/9\//, "/#{@month}/")

      @transacts[date] = {} unless @transacts[date]

      if @transacts[date][barcode]
        @transacts[date][barcode][:quantity] += quantity.to_i
      else
        @transacts[date][barcode] = { quantity: quantity.to_i,
                                      price: @inventory.price(barcode),
                                      date: date }
      end
    end

    file.close
  end

  def save
    # barcode:quantity:price:date
    @transacts.each do |date, items|
      file = File.open("#{date.gsub(/\//, '_')}_#{@output}", 'w')

      items.each do |barcode, detail|
        file.puts "#{barcode}:#{detail[:quantity]}:#{detail[:price].round(2)}:#{detail[:date]}"
      end

      file.rewind
      file.close
    end
  end
end

inventory = Inventory.new(ARGV[0])
inventory.read

converter = Converter.new(inventory, ARGV[1], ARGV[2], ARGV[3])
converter.run
converter.save
