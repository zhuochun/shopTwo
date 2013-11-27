module ProductsHelper

  def display_popularity_stars(sell)
    result = []
    empty, filled  = popularity_stars(sell)

    filled.times do
      result << content_tag(:i, '', class: 'glyphicon glyphicon-star')
    end

    empty.times do
      result << content_tag(:i, '', class: 'glyphicon glyphicon-star-empty')
    end

    result.join("").html_safe
  end

  private

  def popularity_stars(sell)
    if sell    > 900
      [0, 5]
    elsif sell > 700
      [1, 4]
    elsif sell > 500
      [2, 3]
    elsif sell > 300
      [3, 2]
    elsif sell > 100
      [4, 1]
    else
      [5, 0]
    end
  end

end
