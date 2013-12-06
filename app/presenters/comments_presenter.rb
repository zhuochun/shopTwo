class CommentsPresenter
  attr_reader :comments

  def initialize(comments)
    @comments = comments
  end

  def size
    @comments.size
  end

  def empty?
    @comments.empty?
  end

  def count_rating(rating)
    @comments.where(rating: rating).size
  end

  def average_rating
    @comments.average(:rating)
  end

  def new_comment(product, user)
    user.comments.new(product: product)
  end
end
