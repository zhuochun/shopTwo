#!/usr/bin/env ruby
# encoding: utf-8

# ruby convert_to_stocks 'transaction_file.txt' 'output.txt' '0.5'

class Converter

  def initialize(filename, output, multiplier)
    puts "filename: #{filename} -> #{output}"

    @filename   = filename
    @output     = output
    @multiplier = multiplier.to_f
    @stocks     = {}
  end

  def run
    file = File.open(@filename, 'r')

    File.foreach(file) do |line|
      _, _, _, barcode, quantity, _ = line.chomp.force_encoding('UTF-8').split(':')

      if @stocks[barcode]
        @stocks[barcode][:quantity] += quantity.to_i
      else
        @stocks[barcode] = { quantity: quantity.to_i }
      end
    end

    file.close
  end

  def save
    # barcode:quantity:minimum
    file = File.open(@output, 'w')

    @stocks.each do |barcode, item|
      quantity = (item[:quantity] * (@multiplier + 1.0)).to_i
      minimum  = (item[:quantity] * (@multiplier)).to_i

      file.puts "#{barcode}:#{quantity}:#{minimum}"
    end

    file.rewind
    file.close
  end
end

converter = Converter.new(ARGV[0], ARGV[1], ARGV[2])
converter.run
converter.save
