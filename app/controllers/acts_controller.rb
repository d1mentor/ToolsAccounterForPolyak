class ActsController < ApplicationController
  before_action :set_act, only: %i[show edit update destroy]
  before_action :storekeeper_level, only: %i[edit update destroy delete new index]
  before_action :user_level, only: %i[ show ]
  before_action :authenticate_user!, only: %i[new_act_from_qr create]

  # GET /acts or /acts.json
  def index
    @acts = Act.all.sort_by { |act| act.created_at }.reverse
  end

  # GET /acts/1 or /acts/1.json
  def show; end

  # GET /acts/new
  def new
    @act = Act.new
  end

  def new_act_from_qr
    redirect_to '/' if Instrument.find_by(id: params[:instrument_id]).nil?

    @instrument = Instrument.find_by(id: params[:instrument_id])
    @act = Act.new
  end

  # GET /acts/1/edit
  def edit; end

  # POST /acts or /acts.json
  def create
    @act = Act.new(act_params)
    if @act.instrument.acts
      @act.previous_act = @act.instrument.acts.sort_by { |act| act.created_at }.last
      if @act.previous_act && @act.intstrument_state != @act.previous_act.intstrument_state
        tg_newsletter(
          "#{@act.instrument.name} \n Состояние инструмента стало - #{t("states.#{@act.intstrument_state}")} ", 'change_state'
        )
      end
    end

    respond_to do |format|
      if @act.save
        tg_newsletter("#{@act.instrument.name} взял #{@act.user.name}", 'new_act')
        format.html { redirect_to act_url(@act), notice: 'Act was successfully created.' }
        format.json { render :show, status: :created, location: @act }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @act.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /acts/1 or /acts/1.json
  def update
    respond_to do |format|
      if @act.update(act_params)
        format.html { redirect_to act_url(@act), notice: 'Act was successfully updated.' }
        format.json { render :show, status: :ok, location: @act }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @act.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /acts/1 or /acts/1.json
  def destroy
    @act.destroy

    respond_to do |format|
      format.html { redirect_to acts_url, notice: 'Act was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_act
    @act = Act.find(params[:id])
  end

  def after_sign_in_path_for(_resource)
    stored_location = session[:return_to]
    if stored_location && stored_location != '/'
      session.delete(:return_to)
      stored_location
    else
      root_path
    end
  end

  # Only allow a list of trusted parameters through.
  def act_params
    params.require(:act).permit(:intstrument_state, :instrument_id, :user_id, :previous_act_id, :company_id,
                                :comment, { images: [] })
  end
end
