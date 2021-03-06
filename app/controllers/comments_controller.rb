class CommentsController < ApplicationController
  before_action :authorize_owner_or_administrater, only: [:edit, :update, :destroy]
  before_action :authorize_owner, only: [:new]
  before_action :set_comment, only: [:show, :edit, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    if can? :view, Comment
      @filters  = [Comment::APPROVED, Comment::SPAM]
      @filter   = @filters.include?(params[:filter]) ? params[:filter] : Comment::APPROVED
      @comments = Comment.where(flag: @filter).includes(:user).paginate(page: params[:page], per_page: 50)
    else
      @comments = current_user.comments.approved.paginate(page: params[:page], per_page: 50)
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @product = Product.find(comment_params[:product_id])

    # prevent submit multiple comments
    if (@product.has_commented_by(current_user))
      @comment = @product.comment_from(current_user)

      respond_to do |format|
        format.html { redirect_to @comment, notice: 'Review was created before.' }
        format.json { render json: { error: "Review was created before." }, status: :unprocessable_entity }
        format.js
      end

      return
    end

    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Review was successfully created.' }
        format.json { render action: 'show', status: :created, location: @comment }
        format.js
      else
        format.html { render action: 'new' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if params[:delete] == '1'
      @comment.destroy
    else
      @comment.mark_spam
    end

    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:user_id, :product_id, :rating, :content)
    end

    # Authorization
    def authorize_owner_or_administrater
      authorize_user { |u| u.comments.exists?(id: params[:id]) || u.administrater? }
    end
end
