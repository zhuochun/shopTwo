module Commentable
  # can be commented by a user only if one has bought it
  def can_user_comment?(user)
    user && user.bought_items.exists?(product: self)
  end

  # has be commented by a user?
  def has_commented_by(user)
    user && user.comments.exists?(product: self)
  end

  # select the comment by user
  def comment_from(user)
    user ? user.comments.where(product: self) : nil
  end

end
