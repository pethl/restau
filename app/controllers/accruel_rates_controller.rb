class AccruelRatesController < ApplicationController
  before_action :set_accruel_rate, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index]

  # GET /accruel_rates
  # GET /accruel_rates.json
  def index
    @accruel_rates = Accruel_rate.all
  end

  # GET /accruel_rates/1
  # GET /accruel_rates/1.json
  def show
  end

  # GET /accruel_rates/new
  def new
    @accruel_rate = Accruel_rate.new
  end

  # GET /accruel_rates/1/edit
  def edit
  end

  # POST /accruel_rates
  # POST /accruel_rates.json
  def create
    @accruel_rate = Accruel_rate.new(accruel_rate_params)

    respond_to do |format|
      if @accruel_rate.save
        format.html { redirect_to @accruel_rate, notice: 'Accruel rate was successfully created.' }
        format.json { render :show, status: :created, location: @accruel_rate }
      else
        format.html { render :new }
        format.json { render json: @accruel_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /accruel_rates/1
  # PATCH/PUT /accruel_rates/1.json
  def update
    respond_to do |format|
      if @accruel_rate.update(accruel_rate_params)
        format.html { redirect_to @accruel_rate, notice: 'Accruel rate was successfully updated.' }
        format.json { render :show, status: :ok, location: @accruel_rate }
      else
        format.html { render :edit }
        format.json { render json: @accruel_rate.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accruel_rates/1
  # DELETE /accruel_rates/1.json
  def destroy
    @accruel_rate.destroy
    respond_to do |format|
      format.html { redirect_to accruel_rates_url, notice: 'Accruel rate was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_accruel_rate
      @accruel_rate = Accruel_rate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def accruel_rate_params
      params.require(:accruel_rate).permit(:effective_date, :accruel_rate, :rate)
    end
end
