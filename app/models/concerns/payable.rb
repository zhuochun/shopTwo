module Payable
  # get total quantity
  def quantity
    line_items.inject(0) { |sum, item| sum + item.quantity } || 0
  end

  # is empty cart
  def empty?
    quantity < 1
  end

  # is all products out of stock
  def out_of_stocks?
    line_items.any?(&:sufficient_stock?) == false
  end

  # get subtotal
  def subtotal
    line_items.to_a.sum(&:subtotal)
  end

  # get sub total without discount
  def subtotal_without_discount
    line_items.to_a.sum(&:subtotal_without_discount)
  end

  # get discount value subtotal
  def discount_subtotal
    line_items.to_a.sum(&:discount_subtotal)
  end

  # calculate credits earned
  def credits
    subtotal * 0.05
  end
end
