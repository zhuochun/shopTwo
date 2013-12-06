module ProductsHelper

  # display products' stock availability
  def display_product_availability(product)
    content_tag :p, class: "lead text-#{product.in_stock? ? 'success' : 'muted' }" do
      product.in_stock? ? "In Stock" : "Out of Stock"
    end
  end

  # display from 0 to 5 stars
  def display_popularity_stars(sell)
    display_ratings(popularity_stars(sell), 5, 'star')
  end

  private

  def popularity_stars(sell)
    case sell
    when   0...100 then 1
    when 100...300 then 2
    when 300...500 then 3
    when 500...700 then 4
    else 5
    end
  end

end
