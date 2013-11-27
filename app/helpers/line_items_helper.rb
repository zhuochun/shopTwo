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

  # display discount info
  def display_line_item_discount(item)
    unless item.discount < 0.01
      content_tag :small, class: "text-muted" do
        %{
          You Saved: <br> #{number_to_currency item.discount_value}
          (#{number_to_percentage(item.discount * 100, precision: 0)})
        }.html_safe
      end
    end
  end

end
