class MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def create
    @message = Message.new(message_params)
    @message.user_id = current_user.id

    if @message.save
      flash[:notice] = "successfully"
    else
      flash[:alert] = "メッセージ送信に失敗しました。"
    end
    redirect_to "/rooms/#{@message.room_id}"
  end


  # def create
  #   if Entry.where(user_id: current_user.id, room_id: params[:message][:room_id]).present?
  #     @message = Message.create(params.require(:message).permit(:user_id, :message, :room_id).merge(user_id: current_user.id))
  #   else
  #     flash[:alert] = "メッセージ送信に失敗しました。"
  #   end
  # redirect_to "/rooms/#{@message.room_id}"
  # end
  def message_params
    params.require(:message).permit(:message,:user_id,:room_id)
  end
end

