class CashfloatsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index]
  
  before_action :set_cashfloat, only: [:show, :edit, :update, :destroy]

  def validate
  @cashfloat = Cashfloat.find(params[:id]) 
  comment = (params[:float_comment])
      
      if @cashfloat.float_gap == 0 
        @cashfloat.completed = "Completed - OK"
        @cashfloat.float_comment = (params[:float_comment])
        @cashfloat.save
        redirect_to daily_checks_today_path, notice: "Float check completed successfully."
        
      elsif (@cashfloat.float_gap != 0) && !comment.blank?
        @cashfloat.completed = "Completed - Not balanced"
        @cashfloat.float_comment = (params[:float_comment])
        @cashfloat.save
        redirect_to daily_checks_today_path, notice: "Float check completed, float not balanced and reason saved."
      else
        redirect_to edit_cashfloat_path(@cashfloat), :flash => { :warning => "Float does not match target, please give reasons." }
      end
    
end

  # GET /cashfloats
  # GET /cashfloats.json
  def index
    @cashfloats = Cashfloat.all
  end

  # GET /cashfloats/1
  # GET /cashfloats/1.json
  def show
  end

  # GET /cashfloats/new
  def new
    float_target = Cashfloat.float_target(params["float_type"])
    
    @cashfloat = Cashfloat.new
    @cashfloat.period = params["period"]
    @cashfloat.float_type = params["float_type"]
    @cashfloat.two_pound_bag = 0
    @cashfloat.two_pound_single = 0
    @cashfloat.pound_bag = 0
    @cashfloat.pound_single = 0
    @cashfloat.fifty_bag = 0
    @cashfloat.fifty_single = 0
    @cashfloat.twenty_bag = 0
    @cashfloat.twenty_single = 0
    @cashfloat.ten_bag = 0
    @cashfloat.ten_single = 0
    @cashfloat.five_bag = 0
    @cashfloat.five_single = 0
    @cashfloat.two_bag = 0
    @cashfloat.two_single = 0
    @cashfloat.one_bag = 0
    @cashfloat.one_single = 0
    @cashfloat.fifties = 0
    @cashfloat.twenties = 0
    @cashfloat.tens = 0
    @cashfloat.fives = 0
    @cashfloat.float_target = float_target
    
  end

  # GET /cashfloats/1/edit
  def edit
  end

  # POST /cashfloats
  # POST /cashfloats.json
  def create
    @cashfloat = Cashfloat.new(cashfloat_params)
    
    respond_to do |format|
      if @cashfloat.save
        @cashfloat = Cashfloat.count_cash(@cashfloat)
        @cashfloat.save
        format.html { redirect_to edit_cashfloat_path(@cashfloat) }
        format.json { render :show, status: :created, location: @cashfloat }
      else
        format.html { render :new }
        format.json { render json: @cashfloat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cashfloats/1
  # PATCH/PUT /cashfloats/1.json
  def update
     
    respond_to do |format|
      if @cashfloat.update(cashfloat_params)
        @cashfloat = Cashfloat.count_cash(@cashfloat)
        format.html { redirect_to edit_cashfloat_path(@cashfloat) }
        format.json { render :show, status: :ok, location: @cashfloat }
      else
        format.html { render :edit }
        format.json { render json: @cashfloat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cashfloats/1
  # DELETE /cashfloats/1.json
  def destroy
    @cashfloat.destroy
    respond_to do |format|
      format.html { redirect_to cashfloats_url, notice: 'Cashfloat was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cashfloat
      @cashfloat = Cashfloat.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cashfloat_params
      params.require(:cashfloat).permit(:dailybank_id, :float_type, :period, :completed_by, :user_code, :fifties, :twenties, :tens, :fives, :two_pound_single,:pound_single, :fifty_single, :twenty_single, :ten_single, :five_single,:two_single, :one_single, :float_actual, :float_target, :float_gap, :float_comment, :completed, :cheat)
      
    end
end
