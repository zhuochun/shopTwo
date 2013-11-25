module SearchEngine

  class Searchable
    attr_accessor :items, :query, :flags
    attr_reader   :result

    def initialize(items, query, flags)
      @items, @query, @flags = items, query, flags
    end

    def lookup
      found = :continue

      if found == :continue && flags[:barcode]
        found = by_barcode
      end

      if found == :continue && flags[:price]
        found = by_price
      end

      if found == :continue && flags[:price]
        found = by_price_range
      end

      if found == :continue && flags[:name]
        found = by_name
      end

      @result = (found == :continue ? nil : found)
    end

    # regex constants
    BARCODE     = /^\d{8}$/
    PRICE       = /^(?<sign>[<>]?)\s?\$?(?<amount>\d+\.?\d{0,2})\d*$/
    PRICE_RANGE = /^\$?(?<from>\d+\.?\d{0,2})\d*\s*-\s*\$?(?<to>\d+\.?\d{0,2})\d*$/

    # search by barcode
    def by_barcode
      if BARCODE.match(@query)
        @items.where(barcode: @query)
      else
        :continue
      end
    end

    # search by name
    def by_name
      @items.where('lower(name) LIKE ?', "%#{@query.downcase}%")
    end

    # search by price
    def by_price
      if price = PRICE.match(@query)
        # filter sign
        sign = %w(> < =).include?(price[:sign]) ? price[:sign] : "="

        items.where("daily_price #{sign} ?", price[:amount])
      else
        :continue
      end
    end

    # by price range
    def by_price_range
      if price = PRICE_RANGE.match(@query)
        # get range in floats
        range = [price[:from].to_f, price[:to].to_f]

        items.where("daily_price >= ? AND daily_price < ?", range.min, range.max)
      else
        :continue
      end
    end
  end

end
