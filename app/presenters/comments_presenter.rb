class CommentsPresenter
  attr_reader :comments

  def initialize(comments)
    @comments = comments
    @count_rating = {}
  end

  def size
    @size ||= @comments.size
  end

  def empty?
    @comments.empty?
  end

  def count_rating(rating)
    @count_rating[rating] ||= @comments.where(rating: rating).size
  end

  def proportional_rating(rating, scale = 100)
    (count_rating(rating) / size.to_f * scale).ceil
  end

  def average_rating
    @average_rating ||= @comments.average(:rating)
  end

  def new_comment(product, user)
    user.comments.new(product: product)
  end
end
