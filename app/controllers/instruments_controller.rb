class InstrumentsController < ApplicationController
  before_action :set_instrument, only: %i[ show edit update destroy ]
  before_action :storekeeper_level, only: %i[ edit update destroy new edit delete index ]
  before_action :user_level, only: %i[ show ]

  # GET /instruments or /instruments.json
  def index
    @instruments = Instrument.all
  end

  def download_qr
    send_file "#{Rails.root}/public/QR_codes/instrument_#{params[:instrument_id]}_QR_code.png", type: "application/png", x_sendfile: true, filename: "#{Instrument.find_by(id: params[:instrument_id]).name}_QR_CODE.png"
  end

  # GET /instruments/1 or /instruments/1.json
  def show
    @qrcode = RQRCode::QRCode.new("http://#{request.host}/qr/#{@instrument.id}")

    # NOTE: showing with default options specified explicitly
    @png = @qrcode.as_png(
      bit_depth: 1,
      border_modules: 4,
      color_mode: ChunkyPNG::COLOR_GRAYSCALE,
      color: "black",
      file: nil,
      fill: "white",
      module_px_size: 12,
      resize_exactly_to: false,
      resize_gte_to: false,
      size: 240
    )
    
    @qr_image = @png.to_datastream.save("public/QR_codes/instrument_#{@instrument.id}_QR_code.png")

    @instrument = Instrument.find(params[:id])
    @acts = @instrument.acts.includes(:user).order(created_at: :desc)
    @last_act = @instrument.acts.includes(:user).order(created_at: :desc).first
  end

  # GET /instruments/new
  def new
    @instrument = Instrument.new
  end

  # GET /instruments/1/edit
  def edit
  end

  # POST /instruments or /instruments.json
  def create
    @instrument = Instrument.new(instrument_params)

    respond_to do |format|
      if @instrument.save
        format.html { redirect_to instrument_url(@instrument), notice: "Instrument was successfully created." }
        format.json { render :show, status: :created, location: @instrument }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /instruments/1 or /instruments/1.json
  def update
    respond_to do |format|
      if @instrument.update(instrument_params)
        tg_newsletter("#{@instrument.name} изменён", 'change_instrument')
        format.html { redirect_to instrument_url(@instrument), notice: "Instrument was successfully updated." }
        format.json { render :show, status: :ok, location: @instrument }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instrument.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /instruments/1 or /instruments/1.json
  def destroy
    tg_newsletter("#{@instrument.name} set status deleted", 'delete_instrument')
    @instrument.update(state: "broken")

    respond_to do |format|
      format.html { redirect_to instruments_url, notice: "Instrument was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instrument
      @instrument = Instrument.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def instrument_params
      params.require(:instrument).permit(:state, :name, :price, :price_currency, :company_id, {images: []})
    end
end
