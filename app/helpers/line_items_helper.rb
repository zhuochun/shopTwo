module LineItemsHelper

  # range of collection
  def quantity_range(stock)
    if stock > 10
      1..10
    else
      1..stock
    end
  end

end
