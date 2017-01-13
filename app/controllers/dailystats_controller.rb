class DailystatsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]
  
  before_action :set_dailystat, only: [:show, :edit, :update, :destroy]

  # GET /dailystats
  # GET /dailystats.json
  def index
    @dailystats = Dailystat.all
  end

  # GET /dailystats/1
  # GET /dailystats/1.json
  def show
  end

  # GET /dailystats/new
  def new
    @dailystat = Dailystat.new
  end

  # GET /dailystats/1/edit
  def edit
  end

  # POST /dailystats
  # POST /dailystats.json
  def create
    @dailystat = Dailystat.new(dailystat_params)

    respond_to do |format|
      if @dailystat.save
        format.html { redirect_to @dailystat, notice: 'Dailystat was successfully created.' }
        format.json { render :show, status: :created, location: @dailystat }
      else
        format.html { render :new }
        format.json { render json: @dailystat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dailystats/1
  # PATCH/PUT /dailystats/1.json
  def update
    respond_to do |format|
      if @dailystat.update(dailystat_params)
        format.html { redirect_to @dailystat, notice: 'Dailystat was successfully updated.' }
        format.json { render :show, status: :ok, location: @dailystat }
      else
        format.html { render :edit }
        format.json { render json: @dailystat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dailystats/1
  # DELETE /dailystats/1.json
  def destroy
    @dailystat.destroy
    respond_to do |format|
      format.html { redirect_to dailystats_url, notice: 'Dailystat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dailystat
      @dailystat = Dailystat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dailystat_params
      params.require(:dailystat).permit(:action_date, :cancelled_bookings, :confirmed_bookings, :diners_fed, :avg_headcount_per_booking, :avg_days_prior_to_booking, :avg_days_prior_to_booking_under_seven, :avg_days_prior_to_booking_over_six, :dawn, :early, :lunch, :afternoon, :hometime, :evening)
    end
end
