class TroncsController < ApplicationController
  before_action :set_tronc, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]
  
  # GET /troncs
  # GET /troncs.json
  def index
    @troncs = Tronc.all
    @troncs = @troncs.sort_by { |hsh| hsh[:start_date] }.reverse
  end

  # GET /troncs/1
  # GET /troncs/1.json
  def show
  end

  # GET /troncs/new
  def new
    @tronc = Tronc.new
  end

  # GET /troncs/1/edit
  def edit
  end

  # POST /troncs
  # POST /troncs.json
  def create
    @tronc = Tronc.new(tronc_params)

    respond_to do |format|
      if @tronc.save
        format.html { redirect_to @tronc, notice: 'Tronc was successfully created.' }
        format.json { render :show, status: :created, location: @tronc }
      else
        format.html { render :new }
        format.json { render json: @tronc.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /troncs/1
  # PATCH/PUT /troncs/1.json
  def update
    respond_to do |format|
      if @tronc.update(tronc_params)
        format.html { redirect_to @tronc, notice: 'Tronc was successfully updated.' }
        format.json { render :show, status: :ok, location: @tronc }
      else
        format.html { render :edit }
        format.json { render json: @tronc.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /troncs/1
  # DELETE /troncs/1.json
  def destroy
    @tronc.destroy
    respond_to do |format|
      format.html { redirect_to troncs_url, notice: 'Tronc was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tronc
      @tronc = Tronc.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tronc_params
      params.require(:tronc).permit(:start_date, :end_date, :status, :total, :kitchen_split, :foh_split, :card_split, :mgr_split, :foh_method, :kit_method)
    end
end
