module SearchEngine

  class Searchable
    attr_accessor :items, :query, :flags
    attr_reader   :result

    def initialize(items, query, flags)
      @items, @query, @flags = items, query.strip, flags
    end

    def lookup
      @result = :continue

      if use_engine?(:barcode)
        @result = by_barcode
      end

      if use_engine?(:price)
        @result = by_price
      end

      if use_engine?(:price)
        @result = by_price_range
      end

      if use_engine?(:name)
        @result = by_name
      end

      @result = (@result == :continue ? nil : @result)
    end

    def use_engine?(flag)
      @result == :continue && (flags[flag] || flags[:all])
    end

    # regex constants
    BARCODE     = /^\d{8}$/
    PRICE       = /^(?<sign>[<>]?)\s?\$?(?<amount>\d+\.?\d{0,2})\d*$/
    PRICE_RANGE = /^\$?(?<from>\d+\.?\d{0,2})\d*\s*-\s*\$?(?<to>\d+\.?\d{0,2})\d*$/

    # search by barcode
    def by_barcode
      if BARCODE.match(@query)
        if @items.column_names.include?("barcode")
          @items.where(barcode: @query)
        else
          @items.where(id: @query)
        end
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
