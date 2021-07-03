class SearchesController < ApplicationController
  def search
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search], params[:word])
      @user = current_user
      @newbook = Book.new
    else
      @books = Book.looks(params[:search], params[:word])
      @user = current_user
      @newbook = Book.new
    end
  end
end
