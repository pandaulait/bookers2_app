class UsersController < ApplicationController
  def show
  @user = User.find(params[:id])
  @books = @user.books
  @newbook = Book.new
  end

  def index
    @users = User.all
    @user = current_user
    @newbook = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice] = "successfully"
    else
      @user = User.find(params[:id])
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image,:introduction)
  end
end
