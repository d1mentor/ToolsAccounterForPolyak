class ProfilesController < ApplicationController
  before_action :user_level

  def my_profile 
    @user = current_user
    @acts = Act.where(user_id: @user.id).sort_by { |act| act.created_at }.reverse
  end

  def edit
    @user = User.find_by(id: current_user.id)
  end

  def update
    @user = User.find_by(id: current_user.id)

    @user.update(avatar: avatar_params[:avatar])

    redirect_to "/my_profile"
  end

  def avatar_params
    params.require(:user).permit(:avatar)
  end
end
