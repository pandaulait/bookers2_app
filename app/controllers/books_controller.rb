class BooksController < ApplicationController
  def index
    @newbook = Book.new
    if params[:sort_update] == "A"
      @books = Book.order(id: :DESC)
    elsif params[:sort_update] == "B"
      @books = Book.order(evaluation: :DESC)
    elsif params[:sort_update] == "C"
      @books = Book.where(created_at: 1.weeks.ago..Time.now).includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    else
      @books = Book.order(id: :DESC)
    end
    @user = current_user
  end

  def create
    @newbook = Book.new(book_params)
    @newbook.user_id = current_user.id
    if @newbook.save
      flash[:notice] = "successfully"
      redirect_to book_path(@newbook.id)
    else
      @books = Book.all
      @user = current_user
      render 'books/index'
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = current_user
    @newbook = Book.new
    @post_comment = PostComment.new
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
  end
  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book.id)
      flash[:notice] = "successfully"
    else
      render :edit
    end

  end
    def category
    @book =Book.find(params[:id])
    @books = Book.where(category: @book.category)
    @newbook = Book.new
    @user = current_user
    render 'books/index'
  end

  # def search
  #   @books =Book.search(params[:keyword])
  #   @keyword = params[:keyword]
  #   @user = current_user
  #   @newbook = Book.new
  #   render "index"
  # end

  private

  def book_params
    params.require(:book).permit(:title,:body,:evaluation,:category)
  end

end
