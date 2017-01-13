class ExemptionsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new]
  before_action :set_exemption, only: [:show, :edit, :update, :destroy]
  
  # GET /exemptions
  # GET /exemptions.json
  def index
    @exemptions = Exemption.all
  end

  # GET /exemptions/1
  # GET /exemptions/1.json
  def show
  end

  # GET /exemptions/new
  def new
    @exemption = Exemption.new
  end

  # GET /exemptions/1/edit
  def edit
  end

  # POST /exemptions
  # POST /exemptions.json
  def create
    @exemption = Exemption.new(exemption_params)

    respond_to do |format|
      if @exemption.save
        format.html { redirect_to @exemption, notice: 'Exemption was successfully created.' }
        format.json { render :show, status: :created, location: @exemption }
      else
        format.html { render :new }
        format.json { render json: @exemption.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /exemptions/1
  # PATCH/PUT /exemptions/1.json
  def update
    respond_to do |format|
      if @exemption.update(exemption_params)
        format.html { redirect_to @exemption, notice: 'Exemption was successfully updated.' }
        format.json { render :show, status: :ok, location: @exemption }
      else
        format.html { render :edit }
        format.json { render json: @exemption.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exemptions/1
  # DELETE /exemptions/1.json
  def destroy
    @exemption.destroy
    respond_to do |format|
      format.html { redirect_to exemptions_url, notice: 'Exemption was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_exemption
      @exemption = Exemption.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exemption_params
      params.require(:exemption).permit(:exempt_day, :exempt_message)
    end
end
