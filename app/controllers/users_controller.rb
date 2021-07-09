class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @books = @user.books
    @newbook = Book.new
    # グラフ機能
    @book_by_day =@books.where(created_at: 1.weeks.ago..Time.now).group_by_day(:created_at).size
    @chartlabels = @book_by_day.map(&:first).to_json.html_safe
    @chartdatas = @book_by_day.map(&:second)



    # 開いているshowのuserとログインしているuserのentry(相互フォロー関係)を全て変数に格納
    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        # ログインのuserの相互関係を一つずつ
        @userEntry.each do |u|
          # 開いているuserの相互関係を一つずつ
          if cu.room_id == u.room_id then
            # entryをもとに、相互フォローであることを確認できたら、その部屋の鍵を入力
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      unless @isRoom
        # もし、相互関係なのに、部屋がなければルームと相互関係のnew
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def index
    @users = User.all
    @user = current_user
    @newbook = Book.new
  end

  def edit


  end
  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render :edit
    else
        redirect_to user_path(current_user.id)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice] = "successfully"
    else
      render edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image,:introduction)
  end
end

