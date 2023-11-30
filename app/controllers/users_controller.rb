class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :admin_level, only: %i[ edit delete destroy new create set_telegram_id delete_telegram_id notification_settings update_notification_settings ]
  before_action :storekeeper_level, only: %i[ show index ]
  before_action :user_level

  # GET /users or /users.json
  def index
    @users = User.all
  end

  def set_telegram_id
    current_user.update(telegram_id: params[:id])
    redirect_to_root
  end 

  def notification_settings
    @user = current_user
  end

  def update_notification_settings
    @user = current_user

    if @user.update(notification_settings_params)
      flash[:success] = "Notification settings updated successfully."
      redirect_to_root
    else
      flash.now[:error] = "There was an error updating your notification settings."
      render :notification_settings
    end
  end

  def delete_telegram_id
    current_user.update(telegram_id: nil)
    redirect_to_root
  end 

  # GET /users/1 or /users/1.json
  def show
    @acts = Act.where(user_id: @user.id).sort_by { |act| act.created_at }.reverse
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to user_url(@user), notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    # Проверяем, что админ не может изменить свои собственные права
    if @user == current_user && user_params[:role] != current_user.role
      @user.reload
      flash[:alert] = "You cannot change your own role"
      render :edit and return
    end
  
    respond_to do |format|
      if @user.update(user_params)
        unless @user.user?
          format.html { redirect_to user_url(@user), notice: "User was successfully updated." }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { redirect_to "/my_profile", notice: "User was successfully updated." }
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :psw, :email, :password, :encrypted_password, :password_confirmation, :avatar, :phone_number, :notify, :role)
    end

    def notification_settings_params
      params.require(:user).permit(:notify_new_act, :notify_change_state, :notify_delete_instrument, :notify_change_instrument, :notify)
    end
end
