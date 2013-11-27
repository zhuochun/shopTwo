module LineItemsHelper

  # range of collection
  def quantity_range(stock)
    if stock > 10
      1..10
    else
      1..stock
    end
  end

  # display products' stock availability
  def display_line_item_availability(product)
    content_tag :span, class: "text-#{product.in_stock? ? 'success' : 'muted' }" do
      product.in_stock? ? "In Stock" : "Out of Stock"
    end
  end

end
