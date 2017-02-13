class DailybanksController < ApplicationController
 before_action :logged_in_user, only: [:show, :edit, :history, :history_week, :history_month, :index, :update, :destroy]
 before_action :set_dailybank, only: [:show, :edit, :update, :destroy, :submit_comment, :mgmt_lock, :lock_float, :lock_event, :create_new_expense_record, :no_expenses_to_add]
   
 def latest
    @dailybank = Dailybank.last(1).first
 end

  def history
    @dailybanks = []
      #take params from search on History view, or if no search, return 0
      #send to model to apply SEARCH function, which retrieves matching records 
       if params[:from]
         @dailybanks = Dailybank.search(params)
               if @dailybanks.any?
                 # params= []
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
  
  def history_week
    @dailybanks = []
      #take params from search on History view, or if no search, return 0
      #send to model to apply SEARCH function, which retrieves matching records 
       if params[:day]
         @dailybanks = Dailybank.search_week(params)
               if @dailybanks.any?
               # params= []
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
  
  def history_month
    @dailybanks = []

      #take params from search on History view, or if no search, return 0
      #send to model to apply SEARCH function, which retrieves matching records 
     
       if params[:month]
         @dailybanks = Dailybank.search_month(params)
               if @dailybanks.any?
                 # params= []
                 @dailybanks
                 @dailybanks_by_week = @dailybanks.group_by { |t| t.effective_date.strftime("%W") }
       
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
   # @dailybanks = Dailybank.where.not(status: "Locked")
   @dailybanks = Dailybank.where("effective_date >= ?", Date.today.beginning_of_week)
   @dailybanks = @dailybanks.sort_by { |hsh| hsh[:effective_date] } 
  end

  # GET /dailybanks/1
  # GET /dailybanks/1.json
  def show
    @morning_float = Cashfloat.where(:dailybank_id => @dailybank.id, :float_type => "Main Till", :period => "Morning").first
  
  end

  # GET /dailybanks/new
  def new
    if !does_record_exist_for_today?
       @dailybank = Dailybank.new(:status => "Balance Morning Float")
       1.times { @dailybank.cashfloats.build }
  #  @dailybank = Dailybank.new(:status => "Start", :cashfloats_attributes => [{ :float_type => "Main Till", :period => "Morning", :completed_by => current_user.name, :float_target =>Rdetail.get_value(1, "till_float_main") }])
    else
      redirect_to dailybanks_url, notice: 'End of Day already entered for this business day.'
    end
   end
   
   # GET /dailybanks/new
   #def create_new_expense_record
  #   @dailybank.expenses.new
  #   redirect_to edit_dailybank_path(@dailybank)
  # end
  

  # GET /dailybanks/1/edit
  def edit
    @morning_float = Cashfloat.where(:dailybank_id => @dailybank.id, :float_type => "Main Till", :period => "Morning").first
  end

  # POST /dailybanks
  # POST /dailybanks.json
  def create
    @dailybank = Dailybank.new(dailybank_params)

    respond_to do |format|
      if @dailybank.save
        run_calc_rules(@dailybank)
         Cashfloat.count_cash(Cashfloat.where(:dailybank_id => @dailybank.id).first)
        format.html { redirect_to @dailybank }
        format.json { render :show, status: :created, location: @dailybank }
      else
        format.html { render :new }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end

  # This function is used to save the comment if it is not blank
  def submit_comment
   #  Rails.logger.debug("XXXXXXXXX in update: #{dailybank_params[:variance_comment].inspect}")
   if dailybank_params[:variance_comment].length == 0
     redirect_to @dailybank, :flash => { :error => "Please enter a comment to explain your variance."}
   else
    respond_to do |format|
       if @dailybank.update(dailybank_params)
        run_calc_rules(@dailybank)
        format.html { redirect_to @dailybank}
        format.json { render :show, status: :ok, location: @dailybank }
      else
        format.html { render :edit }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end
  end
  
  #This function is used for mgmt_review_re_calculate
  def mgmt_lock
    dailybank_params[:status] = "Locked"
    if @dailybank.update(dailybank_params)
      redirect_to @dailybank, notice: "Thank you for completing End of Day. This record is now locked"
    else  
      redirect_to @dailybank, :flash => { :error => "An error has occurred, please contact IT Support."}
    end
  end

  # PATCH/PUT /dailybanks/1
  # PATCH/PUT /dailybanks/1.json
  def update
    respond_to do |format|
       if @dailybank.update(dailybank_params)
        run_calc_rules(@dailybank)
        Cashfloat.count_cash(Cashfloat.where(:dailybank_id => @dailybank.id, :period =>"Evening").first)
        format.html { redirect_to edit_dailybank_path(@dailybank)}
        format.json { render :show, status: :ok, location: @dailybank }
   else
        format.html { render :edit }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end
  

  # PATCH/PUT /dailybanks/1
  # PATCH/PUT /dailybanks/1.json
  def lock_float
    respond_to do |format|
       if @dailybank.update(dailybank_params)
         @cashfloat = @dailybank.cashfloats.new(float_type: "Main Till", period: "Evening", completed_by: current_user.name, fifties: 0, twenties: 0, tens: 0, fives: 0, two_pound_single: 0, pound_single: 0, fifty_single: 0, twenty_single: 0, ten_single: 0, five_single: 0, two_single: 0, one_single: 0, float_target: Rdetail.get_value(1, "till_float_main"))
         @cashfloat.save
        format.html { redirect_to edit_dailybank_path(@dailybank)}
        format.json { render :show, status: :ok, location: @dailybank }
   else
        format.html { render :edit }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /dailybanks/1
  # PATCH/PUT /dailybanks/1.json
  def lock_event
    respond_to do |format|
       if @dailybank.update(dailybank_params)
         run_calc_rules(@dailybank)
         format.html { redirect_to edit_dailybank_path(@dailybank)}
        format.json { render :show, status: :ok, location: @dailybank }
   else
        format.html { render :edit }
        format.json { render json: @dailybank.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # PATCH/PUT /dailybanks/1
  # PATCH/PUT /dailybanks/1.json
  def no_expenses_to_add
    respond_to do |format|
       if @dailybank.update(dailybank_params)
         run_calc_rules(@dailybank)
         format.html { redirect_to edit_dailybank_path(@dailybank)}
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
      params.require(:dailybank).permit(:user_id, :effective_date, :till_cash, :till_float, :card_payments, :card_1, :card_2, :expenses_total, :actual_cash_total, :till_takings_check, :till_takings, :wet_takings, :dry_takings, :merch_takings, :vouchers_sold, :vouchers_used, :deposit_sold, :deposit_used, :actual_till_takings, :reported_till_takings, :v_d_adjustments, :total_eft_taken, :total_expected_cash, :calculated_variance, :user_variance, :variance_comment, :status, :variance_gap, :banking, :cashfloats_attributes => [:id, :dailybank_id, :float_type, :period, :completed_by, :user_code, :fifties, :twenties, :tens, :fives, :two_pound_single, :pound_single, :fifty_single, :twenty_single, :ten_single, :five_single, :two_single, :one_single, :float_actual, :float_target, :float_gap, :float_comment, :completed, :cheat, :override], :expenses_attributes => [:id, :dailybank_id, :what, :where, :price, :ref, :_destroy] )
    end
    
    def run_calc_rules(dailybank)
      #good
      if (!dailybank.till_float.blank? && !dailybank.till_cash.blank?)
        dailybank.update_attribute(:banking, (dailybank.till_cash-dailybank.till_float))
       end
      #good
      if (!dailybank.card_1.blank? && !dailybank.card_2.blank?)
        dailybank.update_attribute(:card_payments, (dailybank.card_1+dailybank.card_2))
      end
      #good
      if (!dailybank.banking.blank? && !dailybank.card_payments.blank? && !dailybank.expenses_total.blank?)
        dailybank.update_attribute(:actual_cash_total, (dailybank.banking+dailybank.card_payments+dailybank.expenses_total))
      else
       end
       #good
       if (!dailybank.wet_takings.blank? && !dailybank.dry_takings.blank? && !dailybank.merch_takings.blank?)
         dailybank.update_attribute(:till_takings, (dailybank.wet_takings+dailybank.dry_takings+dailybank.merch_takings))
        else
       end 
       #good
       if (!dailybank.till_takings.blank? && !dailybank.reported_till_takings.blank?)
         if (dailybank.till_takings-dailybank.reported_till_takings==0)
         dailybank.update_attribute(:till_takings_check, true)
       else
         dailybank.update_attribute(:till_takings_check, false)
       end
        else
       end 
       
       #test
       if (!dailybank.vouchers_sold.blank? && !dailybank.vouchers_used.blank? && !dailybank.deposit_sold.blank? && !dailybank.deposit_used.blank?)
         dailybank.update_attribute(:v_d_adjustments, ((dailybank.vouchers_sold+dailybank.deposit_sold)-(dailybank.deposit_used+dailybank.vouchers_used)))
        else
       end 
       #bad
        if (!dailybank.actual_cash_total.blank? && !dailybank.actual_till_takings.blank?)
          dailybank.update_attribute(:calculated_variance, (dailybank.actual_cash_total-dailybank.actual_till_takings))
        else
         
        end
        if (!dailybank.calculated_variance.blank? && !dailybank.user_variance.blank?)
          dailybank.update_attribute(:variance_gap, (dailybank.user_variance-dailybank.calculated_variance))
        else
          #Rails.logger.debug("in 3rd else: #{dailybank}")
        end
      end
      
       
       #check if there is already a daily bank record for effective date of today - where today is
       def does_record_exist_for_today?
         if Time.now < "05:00:10"
          # start_time = DateTime.yesterday.beginning_of_day.change({ hour: 05, min: 01 })
          # end_time = Time.now.beginning_of_day.change({ hour: 05, min: 00 })
          today_date = Date.yesterday
         else 
        #  start_time = Time.now.beginning_of_day.change({ hour: 05, min: 01 })
        #  end_time = DateTime.tomorrow.beginning_of_day.change({ hour: 05, min: 00 })
        today_date = Date.today
         end
        if Dailybank.where('DATE(effective_date) = ?', today_date).count >0
          return true
        else
          return false
        end
      end
end
