class RdetailsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]
  before_action :set_rdetail, only: [:show, :edit, :update, :destroy]

  # GET /rdetails
  # GET /rdetails.json
  def index
    @rdetails = Rdetail.all
  end

  # GET /rdetails/1
  # GET /rdetails/1.json
  def show
    
  end

  # GET /rdetails/new
  def new
    @rdetail = Rdetail.new
  end

  # GET /rdetails/1/edit
  def edit
  end

  # POST /rdetails
  # POST /rdetails.json
  def create
    @rdetail = Rdetail.new(rdetail_params)

    respond_to do |format|
      if @rdetail.save
        format.html { redirect_to @rdetail, notice: 'Rdetail was successfully created.' }
        format.json { render :show, status: :created, location: @rdetail }
      else
        format.html { render :new }
        format.json { render json: @rdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rdetails/1
  # PATCH/PUT /rdetails/1.json
  def update
    respond_to do |format|
      if @rdetail.update(rdetail_params)
        format.html { redirect_to @rdetail, notice: 'Rdetail was successfully updated.' }
        format.json { render :show, status: :ok, location: @rdetail }
      else
        format.html { render :edit }
        format.json { render json: @rdetail.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rdetails/1
  # DELETE /rdetails/1.json
  def destroy
    @rdetail.destroy
    respond_to do |format|
      format.html { redirect_to rdetails_url, notice: 'Rdetail was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rdetail
      @rdetail = Rdetail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rdetail_params
      params.require(:rdetail).permit(:restaurant_id, :wed_thurs_eve_max_diners, :booking_duration, :min_booking, :max_booking, :max_diners_at_current_time, :last_booking_time, :max_current_diners, :current_diners_window_start, :current_diners_window_end, :big_table_count, :large_table_count, :safe_float, :till_float_main, :till_float_bar, :afternoon_full_diners, :day_full_diners, :eve_full_diners)
    end
end
