class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy


    @currentUserEntry=Entry.where(user_id: current_user.id)
    @userEntry=Entry.where(user_id: :user_id)
    unless :user_id == current_user.id
      @currentUserEntry.each do |cu|
        # ログインのuserの相互関係を一つずつ
        @userEntry.each do |u|
          # 開いているuserの相互関係を一つずつ
          if cu.room_id == u.room_id then
            # entryをもとに、相互フォローであることを確認できたら、その部屋の鍵を入力
            room =Room.find_by(id: cu.room_id)
            room.destroy
            @roomId = cu.room_id
          end
        end
      end
    end
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
