class DailybanksController < ApplicationController
  before_action :set_dailybank, only: [:show, :edit, :update, :destroy]

  def history
    @dailybanks = []

      #take params from search on History view, or if no search, return 0
      #send to model to apply SEARCH function, which retrieves matching records 
     
       if params[:from]
         @dailybanks = Dailybank.search(params)
               if @dailybanks.any?
                 params= []
                 @dailybanks
             else
                 params= []
                 @dailybanks = 1
               end
       else
         @dailybanks = 0
         params= []
       end
     
  end
  
  # GET /dailybanks
  # GET /dailybanks.json
  def index
    @dailybanks = Dailybank.all
  end

  # GET /dailybanks/1
  # GET /dailybanks/1.json
  def show
  end

  # GET /dailybanks/new
  def new
    @dailybank = Dailybank.new
  end

  # GET /dailybanks/1/edit
  def edit
  end

  # POST /dailybanks
  # POST /dailybanks.json
  def create
    @dailybank = Dailybank.new(dailybank_params)

    respond_to do |format|
      if @dailybank.save
        run_calc_rules(@dailybank)
        format.html { redirect_to @dailybank, notice: 'Dailybank was successfully created.' }
        format.json { render :show, status: :created, location: @dailybank }
      else
        format.html { render :new }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dailybanks/1
  # PATCH/PUT /dailybanks/1.json
  def update
    respond_to do |format|
      if @dailybank.update(dailybank_params)
        run_calc_rules(@dailybank)
        
        format.html { redirect_to @dailybank, notice: 'Dailybank was successfully updated.' }
        format.json { render :show, status: :ok, location: @dailybank }
      else
        format.html { render :edit }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dailybanks/1
  # DELETE /dailybanks/1.json
  def destroy
    @dailybank.destroy
    respond_to do |format|
      format.html { redirect_to dailybanks_url, notice: 'Dailybank was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dailybank
      @dailybank = Dailybank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dailybank_params
      params.require(:dailybank).permit(:user_id, :effective_date, :till_cash, :till_float, :card_payments, :expenses, :actual_cash_total, :till_takings, :wet_takings, :dry_takings, :merch_takings, :vouchers_sold, :vouchers_used, :deposit_sold, :deposit_used, :actual_till_takings, :calculated_variance, :user_variance, :varaince_comment, :status, :variance_gap)
    end
    
    def run_calc_rules(dailybank)
     
      if (!dailybank.till_cash.blank? && !dailybank.till_float.blank? && !dailybank.card_payments.blank? && !dailybank.expenses.blank? )
        dailybank.update_attribute(:actual_cash_total, ((dailybank.till_cash+dailybank.card_payments+dailybank.expenses)-dailybank.till_float))
      else
         Rails.logger.debug("in else: #{dailybank}")
       end
       
     if (!dailybank.till_takings.blank? && !dailybank.vouchers_sold.blank? && !dailybank.vouchers_used.blank? && !dailybank.deposit_sold.blank? && !dailybank.deposit_used.blank?)
       dailybank.update_attribute(:actual_till_takings, ((dailybank.till_takings+dailybank.vouchers_sold+dailybank.deposit_sold)-(dailybank.deposit_used+dailybank.vouchers_used)))
      else
        Rails.logger.debug("in 2nd else: #{dailybank}")
      end 
        if (!dailybank.actual_cash_total.blank? && !dailybank.actual_till_takings.blank?)
          dailybank.update_attribute(:calculated_variance, (dailybank.actual_cash_total-dailybank.actual_till_takings))
        else
          Rails.logger.debug("in 3rd else: #{dailybank}")
        end
        if (!dailybank.calculated_variance.blank? && !dailybank.user_variance.blank?)
          dailybank.update_attribute(:variance_gap, (dailybank.user_variance-dailybank.calculated_variance))
        else
          Rails.logger.debug("in 3rd else: #{dailybank}")
        end
      
    #  dailybank.actual_till_takings =  self.till_takings+self.vouchers_sold-self.vouchers_used+self.deposit_sold-self.deposit_used
    #  dailybank.calculated_variance =  self.actual_cash_total-self.actual_till_takings
    #  dailybank.variance_gap = self.user_variance - self.calculated_variance
    end
end
