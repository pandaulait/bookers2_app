class FindersController < ApplicationController
  def finder
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      @user = current_user
      @newbook = Book.new
      render 'users/index'
    else
      @books = Book.looks(params[:search], params[:word])
      @user = current_user
      @newbook = Book.new
      render 'books/index'
    end
  end
end
