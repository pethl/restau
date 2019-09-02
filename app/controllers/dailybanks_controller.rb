class DailybanksController < ApplicationController
 before_action :logged_in_user, only: [:show, :edit, :latest, :tax_quarter, :index_full, :index_ongoing, :history, :history_week, :history_month, :index, :update, :destroy]
 before_action :set_dailybank, only: [:show, :edit, :update, :destroy, :submit_comment, :mgmt_lock, :lock_float, :lock_event, :create_new_expense_record, :no_expenses_to_add, :mgmt_review, :put_to_mgmt_review, :mgmt_recalculate]
   
 def latest
    @dailybank = Dailybank.last(1).first
 end
 
 def mgmt_review
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
  
  def tax_quarter
    @dailybanks = []
      #take params from search on tax_quarter view, or if no search, return 0
      #send to model to apply SEARCH function, which retrieves matching records 
       if params[:from]
         @dailybanks = Dailybank.search(params)
               if @dailybanks.any?
                 # params= []
                 @dailybanks_by_month = @dailybanks.group_by { |t| t.effective_date.strftime("%b") }
                # @dailybanks_by_month
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
  
  def card_tips_report
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
   @dailybanks = Dailybank.where("effective_date >= ?", Date.today.beginning_of_week.-(7.days))
   @dailybanks = @dailybanks.sort_by { |hsh| hsh[:effective_date] } 
  end
  
  def index_full
   @dailybanks = Dailybank.all
   @dailybanks = @dailybanks.sort_by { |hsh| hsh[:effective_date] }.reverse 
  end

  def index_ongoing
   @dailybanks = Dailybank.where.not(status: "Locked")
   @dailybanks = @dailybanks.sort_by { |hsh| hsh[:effective_date] }.reverse 
  end


  # GET /dailybanks/1
  # GET /dailybanks/1.json
  def show
    @morning_float = Cashfloat.where(:dailybank_id => @dailybank.id, :float_type => "Main Till", :period => "Morning").first
  end

  # GET /dailybanks/new
  def new
       @dailybank = Dailybank.new(:status => "Balance Morning Float")
       1.times { @dailybank.cashfloats.build }
   end
   
   # GET /dailybanks/new
   #def create_new_expense_record
  #   @dailybank.expenses.new
  #   redirect_to edit_dailybank_path(@dailybank)
  # end
  

  # GET /dailybanks/1/edit
  def edit
    @morning_float = Cashfloat.where(:dailybank_id => @dailybank.id, :float_type => "Main Till", :period => "Morning").first
    @evening_float = Cashfloat.where(:dailybank_id => @dailybank.id, :float_type => "Main Till", :period => "Evening").first
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
    @dailybank.update_attribute(:status, "Locked")
      redirect_to @dailybank, notice: "Thank you for reviewing End of Night. This record is now locked"
  end
  
  # PATCH/PUT /dailybanks/1
  # PATCH/PUT /dailybanks/1.json
  def update
    respond_to do |format|
       if @dailybank.update(dailybank_params)
        run_calc_rules(@dailybank)
        Cashfloat.count_cash(Cashfloat.where(:dailybank_id => @dailybank.id, :period =>"Evening").first)
        if dailybank_params[:status]=="Mgmt re-calc"
           format.html { redirect_to mgmt_review_dailybank_path(@dailybank)}
         else
        format.html { redirect_to edit_dailybank_path(@dailybank)}
        format.json { render :show, status: :ok, location: @dailybank }
      end
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
         unless @dailybank.cashfloats.count ==2
         @cashfloat = @dailybank.cashfloats.new(float_type: "Main Till", period: "Evening", completed_by: current_user.name, fifties: 0, twenties: 0, tens: 0, fives: 0, two_pound_single: 0, pound_single: 0, fifty_single: 0, twenty_single: 0, ten_single: 0, five_single: 0, two_single: 0, one_single: 0, float_target: Rdetail.get_value(1, "till_float_main"))
         @cashfloat.save
       end
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

  def put_to_mgmt_review
    @dailybank.update_attribute(:status, "Mgmt Review")
     redirect_to edit_dailybank_path(@dailybank)
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
  
  def download_end_of_night_pdf
    @dailybank_id = params[:value]
    @dailybank = Dailybank.where(id: @dailybank_id).first
    @morning_till = Cashfloat.where(dailybank_id: @dailybank_id, float_type: "Main Till", period: "Morning" ).first
    @evening_till = Cashfloat.where(dailybank_id: @dailybank_id, float_type: "Main Till", period: "Evening" ).first
    @expenses = Expense.where(dailybank_id: @dailybank_id)
   
    respond_to do |format|
      format.pdf do
        pdf = Prawn::Document.new
        pdf.text "End of Night Report for : " + @dailybank.effective_date.strftime('%d %b, %Y'), size: 14, style: :bold
        pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n", size: 6
        pdf.text "\n", size: 8
        
        pdf.text "MORNING FLOAT" + "\n", style: :bold, size: 9
        pdf.text "Complete by: " + @morning_till.completed_by + "     Comments: "+ @morning_till.float_comment + "\n", size: 6
        table_data = Array.new
        table_data << ["Target = #{@morning_till.float_target.to_s}", "£50", "£20", "£10", "£5", "£2", "£1", "50p", "20p", "10p", "5p", "2p", "1p"]
        table_data << ["Total", @morning_till.fifties, @morning_till.twenties, @morning_till.tens, @morning_till.fives, @morning_till.two_pound_single, @morning_till.pound_single, (sprintf "%.2f", @morning_till.fifty_single), (sprintf "%.2f", @morning_till.twenty_single), (sprintf "%.2f", @morning_till.ten_single), (sprintf "%.2f", @morning_till.five_single), (sprintf "%.2f", @morning_till.two_single), (sprintf "%.2f", @morning_till.one_single) ]
        table_data << ["£#{(sprintf "%.2f", @morning_till.float_actual.to_s)}"]
        
        pdf.table(table_data, :column_widths => [100,30,30,30,30,30,30,30,30,30,30,30,30],:cell_style => {:padding => 3}) do 
          self.width = 460
          self.cell_style = { :inline_format => true, size: 8 } 
          self.row_colors = ["DDDDDD", "FFFFFF"]
          self.header = true
          row(0).font_style = :bold
          row(2).font_style = :bold
          columns(0..12).align = :right
          row(2).border_width = 2
        end
        
        pdf.text "\n", size: 10
        pdf.text "EVENING TILL" + "\n", style: :bold, size: 9
        pdf.text "Complete by: " + @evening_till.completed_by + "     Comments: "+ @evening_till.float_comment.to_s + "\n", size: 6
        table_data = Array.new
        table_data << ["AM Float = #{@morning_till.float_actual.to_s}", "£50", "£20", "£10", "£5", "£2", "£1", "50p", "20p", "10p", "5p", "2p", "1p"]
        table_data << ["Total", @evening_till.fifties, @evening_till.twenties, @evening_till.tens, @evening_till.fives, @evening_till.two_pound_single, @evening_till.pound_single, (sprintf "%.2f", @evening_till.fifty_single), (sprintf "%.2f", @evening_till.twenty_single), (sprintf "%.2f", @evening_till.ten_single), (sprintf "%.2f", @evening_till.five_single), (sprintf "%.2f", @evening_till.two_single), (sprintf "%.2f", @evening_till.one_single) ]
        table_data << ["£#{(sprintf "%.2f", @evening_till.float_actual.to_s)}"]
          
        pdf.table(table_data, :column_widths => [100,30,30,30,30,30,30,30,30,30,30,30,30],:cell_style => {:padding => 3}) do 
          self.width = 460
          self.cell_style = { :inline_format => true, size: 8 } 
          self.row_colors = ["DDDDDD", "FFFFFF"]
          self.header = true
          row(0).font_style = :bold
          row(2).font_style = :bold
          columns(0..12).align = :right
          row(2).border_width = 2
          end
        pdf.text "\n", size: 10
        pdf.text "EXPENSES" + "\n", style: :bold, size: 9
        table_data = Array.new
        table_data << ["Total", "Ref", "What", "Where", "Price"]
        @expenses.each do |expense|
            table_data << ["  ", expense.ref, expense.what, expense.where, (sprintf "%.2f", expense.price)]
        end
        table_data << ["£#{(sprintf "%.2f", @expenses.sum(:price).to_s)}"]
        
        pdf.table(table_data, :column_widths => [100, 45,185,80,50], :cell_style => {:padding => 3}) do 
          self.width = 460
          self.cell_style = { :inline_format => true, size: 8 } 
          self.row_colors = ["DDDDDD", "FFFFFF"]
          self.header = true
          
          row(0).font_style = :bold
          row(-1).font_style = :bold
          #row().padding = 2
          columns(0).align = :right
          columns(1..3).align = :left
          columns(4).align = :right
          row(-1).border_width = 2
             end
         
         pdf.text "\n", size: 10
         pdf.text "CARD MACHINES" + "\n", style: :bold, size: 9
         table_data = Array.new
         table_data << ["Total", "Card 1", (sprintf "%.2f", @dailybank.card_1), "Gratuity 1", (sprintf "%.2f", @dailybank.gratuity_1)]
         table_data << [" ", "Card 2", (sprintf "%.2f", @dailybank.card_2), "Gratuity 2", (sprintf "%.2f", @dailybank.gratuity_2), "Gratuity Total", (sprintf "%.2f", @dailybank.gratuity_total)]
         table_data << ["£#{(sprintf "%.2f", @dailybank.card_payments.to_s)}"]
         pdf.table(table_data, :column_widths => [100,80,60],:cell_style => {:padding => 3}) do 
           self.width = 410
           self.cell_style = { :inline_format => true, size: 8 } 
           self.row_colors = ["DDDDDD", "FFFFFF"]
           self.header = true
          
           row(2).font_style = :bold
           columns(0).width = 100
           columns(0..6).align = :right
           columns(1).width = 50
           columns(2).width = 50
           columns(3).width = 50
           columns(4).width = 50
           columns(5).width = 60
           columns(6).width = 50
           row(2).border_width = 2
          end
          
          pdf.text "\n", size: 10
          pdf.text "BACS", style: :bold, size: 9
          table_data = Array.new
          table_data << ["£#{(sprintf "%.2f", @dailybank.bacs.to_s)}" ]
          pdf.table(table_data, :column_widths => [100],:cell_style => {:padding => 3}) do 
            self.width = 100
            self.cell_style = { :inline_format => true, size: 8 } 
            row(0).font_style = :bold
            columns(0).align = :right
            row(0).border_width = 2
             end  
         
          
          pdf.text "\n", size: 10
          pdf.text "TAKINGS                          BANKING", style: :bold, size: 9
          table_data = Array.new
          table_data << ["£#{(sprintf "%.2f", @dailybank.actual_cash_total.to_s)}", "£#{(sprintf "%.2f", @dailybank.banking.to_s)}"]
          pdf.table(table_data, :column_widths => [100,100],:cell_style => {:padding => 3}) do 
            self.width = 200
            self.cell_style = { :inline_format => true, size: 8 } 
            row(0).font_style = :bold
            columns(0..1).align = :right
          end
             
             pdf.text "\n", size: 10
             pdf.text "VARIANCE", style: :bold, size: 9
             table_data = Array.new
             table_data << ["£#{(sprintf "%.2f", @dailybank.calculated_variance.to_s)}" ]
             pdf.table(table_data, :column_widths => [100],:cell_style => {:padding => 3}) do 
               self.width = 100
               self.cell_style = { :inline_format => true, size: 8 } 
               row(0).font_style = :bold
               columns(0).align = :right
               row(0).border_width = 2
                end  
             #  pdf.text "\nComment: " + @dailybank.variance_comment, size: 8 
          
         pdf.text "\n", size: 10
         pdf.text "From Till Z Report\n", size: 9
         table_data = Array.new
         table_data << ["Total Sales", "£#{(sprintf "%.2f", @dailybank.actual_till_takings.to_s)}"]
         table_data << ["Vouchers Sold", "£#{(sprintf "%.2f", @dailybank.vouchers_sold.to_s)}"]
         table_data << ["Vouchers Used", "£#{(sprintf "%.2f", @dailybank.vouchers_used.to_s)}"]
         table_data << ["Deposits Sold", "£#{(sprintf "%.2f", @dailybank.deposit_sold.to_s)}"]
         table_data << ["Deposits Used", "£#{(sprintf "%.2f", @dailybank.deposit_used.to_s)}"]
         table_data << ["Cash", "£#{(sprintf "%.2f", @dailybank.total_expected_cash.to_s)}"]
         table_data << ["Card", "£#{(sprintf "%.2f", @dailybank.total_eft_taken.to_s)}"]
          table_data << [" "]
         table_data << ["Sales", "£#{(sprintf "%.2f", @dailybank.till_takings.to_s)}"]
         table_data << ["Wet", "£#{(sprintf "%.2f", @dailybank.wet_takings.to_s)}"]
         table_data << ["Dry", "£#{(sprintf "%.2f", @dailybank.dry_takings.to_s)}"]
         table_data << ["Misc", "£#{(sprintf "%.2f", @dailybank.merch_takings.to_s)}"]
         
         pdf.table(table_data, :column_widths => [100,100],:cell_style => {:padding => 3}) do 
           self.width = 200
           self.cell_style = { :inline_format => true, size: 8 } 
           row(0).font_style = :bold
           row(8).font_style = :bold
           columns(0).align = :left
           columns(1).align = :right
           row(7).border_width = 0
           row(8).border_width = 2
           row(0).border_width = 2
            end 
     send_data pdf.render, filename: 'end_of_night.pdf', type: 'application/pdf', :disposition => 'inline'
     end
   end
 end
  
 def download_card_tips_report_pdf
   @start_date = params[:value]
   @end_date = (@start_date.to_date.end_of_month)
   @dailybanks = Dailybank.where("effective_date BETWEEN ? AND ?", @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day).sort_by { |hsh| hsh[:effective_date] }
   @dailybanks_by_week = @dailybanks.group_by { |t| t.effective_date.strftime("%V") }
  
   respond_to do |format|
    format.pdf do
      #DOCUMENT SETUP_START
      pdf = Prawn::Document.new
      pdf.text "Card Tips Report : " + @start_date.to_date.strftime('%d %b, %Y') + " - " + @end_date.to_date.strftime('%d %b, %Y'), size: 14, style: :bold
      pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n", size: 6
      #DOCUMENT SETUP_END  
      
      #WEEKLY_SUMMARY_START
      @dailybanks_by_week.each do |week, dailybanks|
      pdf.text "\n", size: 6  
      pdf.text "Week Number " + week, size: 8, style: :bold 
        
        table_data = Array.new
        table_data << ["Date", "Card Tips"]
            dailybanks.each do |dailybank|
              table_data << [dailybank.effective_date.strftime('%e: %a'), dailybank.gratuity_total]
            end
        table_data << ["Total", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:gratuity_total] }.compact.sum.to_s)}"]
           pdf.table(table_data) do 
             self.width = 100 
             self.cell_style = { :inline_format => true, size: 6 } 
              row(0).font_style = :bold
               row(-1).font_style = :bold
             columns(0..1).width = 50
             columns(0).align = :left
             columns(1).align = :right
            
          end
        end
         send_data pdf.render, filename: 'card_tips.pdf', type: 'application/pdf', :disposition => 'inline'
      end
    end
  
 end
  
  
  
  def download_dailybank_tax_accounting_pdf
   @start_date = params[:value]
   @end_date = (@start_date.to_date+3.months)-1.day
   @dailybanks = Dailybank.where("effective_date BETWEEN ? AND ?", @start_date.to_date.beginning_of_day, @end_date.to_date.end_of_day).sort_by { |hsh| hsh[:effective_date] }
   @dailybanks_by_month = @dailybanks.group_by { |t| t.effective_date.strftime("%b") }
   @dailybanks_by_week = @dailybanks.group_by { |t| t.effective_date.strftime("%U") }
   
   respond_to do |format|
    format.pdf do
      #DOCUMENT SETUP_START
      pdf = Prawn::Document.new
      pdf.text "Tax Quarter Report : " + @start_date.to_date.strftime('%d %b, %Y') + " - " + @end_date.to_date.strftime('%d %b, %Y'), size: 14, style: :bold
      pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n", size: 6
      pdf.text "\n", size: 8
      #DOCUMENT SETUP_END
      
      #SALES_SUMMARY_START
      pdf.text "SUMMARY SALES FIGURES" + "\n", size: 10
        table_data_sales = Array.new
        table_data_sales << ["Month","Food", "Drink", "Merchandise", "Deposits/\nVouchers", "Total"]
         
        @dailybanks_by_month.each do |month, dailybanks|
          table_data_sales << [month, "£#{(sprintf "%.2f", dailybanks.map { |h| h[:dry_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:wet_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:merch_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:v_d_adjustments] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", ((dailybanks.map { |h| h[:till_takings] }.compact.sum)+(dailybanks.map { |h| h[:v_d_adjustments] }.compact.sum)).to_s)}"]      
      end
        table_data_sales << ["Total", "£#{(sprintf "%.2f", @dailybanks.map { |h| h[:dry_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", @dailybanks.map { |h| h[:wet_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", @dailybanks.map { |h| h[:merch_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", @dailybanks.map { |h| h[:v_d_adjustments] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", ((@dailybanks.map { |h| h[:till_takings] }.compact.sum)+(@dailybanks.map { |h| h[:v_d_adjustments] }.compact.sum)).to_s)}"]      
        
        pdf.table(table_data_sales) do 
          self.width = 340 
          self.cell_style = { :inline_format => true, size: 8 } 
          self.row_colors = ["DDDDDD", "FFFFFF"]
        
          row(0).font_style = :bold
          columns(0).width = 40
          columns(1..7).width = 60
          columns(1..7).align = :right
          row(-1).font_style = :bold
        end
      #SALES_SUMMARY_END
      
      #WEEKLY_SUMMARY_START
      pdf.text "\n\n", size: 8
      pdf.text "SUMMARY BY WEEK" + "\n", size: 10
    
      @dailybanks_by_week.each do |week, dailybanks|
      pdf.text "\n\n", size: 6  
      pdf.text "Week Number " + week, size: 10, style: :bold 
        
        table_data = Array.new
        table_data << ["Date", "Takings", "Cash", "Cards", "Expenses", "Var", "Food", "Drink", "Merch", "D & V\nAdjustment"]
        dailybanks.each do |dailybank|
          if ["Locked", "Mgmt Review", "Mgmt re-calc"].include? dailybank.status
            #reject record is status doesn't suggest values will be completed as would cause error
            takings = (dailybank.banking+dailybank.card_payments+dailybank.expenses.sum(:price)-dailybank.calculated_variance)
            table_data << [dailybank.effective_date.strftime('%d %b'), "£#{(sprintf "%.2f", takings.to_s)}", "£#{(sprintf "%.2f", dailybank.banking.to_s)}", "£#{(sprintf "%.2f", dailybank.card_payments.to_s)}", "£#{(sprintf "%.2f", dailybank.expenses_total.to_s)}", "£#{(sprintf "%.2f", dailybank.calculated_variance.to_s)}", "£#{(sprintf "%.2f", dailybank.dry_takings.to_s)}", "£#{(sprintf "%.2f", dailybank.wet_takings.to_s)}", "£#{(sprintf "%.2f", dailybank.merch_takings.to_s)}", "£#{(sprintf "%.2f", dailybank.v_d_adjustments.to_s)}"]
           else
          end
        end
        takings_total = ((dailybanks.map { |h| h[:banking] }.compact.sum)+(dailybanks.map { |h| h[:card_payments] }.compact.sum)+(dailybanks.map { |h| h[:expenses_total] }.compact.sum)-(dailybanks.map { |h| h[:calculated_variance] }.compact.sum))
        table_data <<["Total","£#{(sprintf "%.2f", takings_total.to_s)}" , "£#{(sprintf "%.2f", dailybanks.map { |h| h[:banking] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:card_payments] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:expenses_total] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:calculated_variance] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:dry_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:wet_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:merch_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:v_d_adjustments] }.compact.sum.to_s)}"]
        
        pdf.table(table_data) do 
          self.width = 535 
          self.cell_style = { :inline_format => true, size: 8 } 
          self.row_colors = ["DDDDDD", "FFFFFF"]
          self.header = true
      
          row(0).font_style = :bold
          columns(0).width = 40
        #  columns(0).font_style = :bold
          columns(1..9).width = 55
          columns(1..9).align = :right
          row(-1).font_style = :bold
          #row(-2).font_style = :bold
         end
         end
         #WEEKLY_SUMMARY_END
 
         #MONTHLY_SUMMARY_START
         pdf.text "\n\n", size: 8
         pdf.text "SUMMARY BY MONTH" + "\n", size: 10
    
         @dailybanks_by_month.each do |month, dailybanks|
         pdf.text "\n", size: 8
           table_data = Array.new
           table_data << [month, "Takings", "Cash", "Cards", "Expenses", "Var", "Food", "Drink", "Merch", "D & V\nAdjustment"]
           takings_total = ((dailybanks.map { |h| h[:banking] }.compact.sum)+(dailybanks.map { |h| h[:card_payments] }.compact.sum)+(dailybanks.map { |h| h[:expenses_total] }.compact.sum)-(dailybanks.map { |h| h[:calculated_variance] }.compact.sum))
           table_data <<["","£#{(sprintf "%.2f", takings_total.to_s)}" , "£#{(sprintf "%.2f", dailybanks.map { |h| h[:banking] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:card_payments] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:expenses_total] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:calculated_variance] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:dry_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:wet_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:merch_takings] }.compact.sum.to_s)}", "£#{(sprintf "%.2f", dailybanks.map { |h| h[:v_d_adjustments] }.compact.sum.to_s)}"]
        
           pdf.table(table_data) do 
             self.width = 535 
             self.cell_style = { :inline_format => true, size: 8 } 
             self.row_colors = ["DDDDDD", "FFFFFF"]
             self.header = true
      
             row(0).font_style = :bold
             columns(0).width = 40
             columns(1..9).width = 55
             columns(1..9).align = :right
             row(-1).font_style = :bold
            end
            end
            #MONTHLY_SUMMARY_END
          pdf.text "\n", size: 12
          
     
       send_data pdf.render, filename: 'tax_quarter.pdf', type: 'application/pdf', :disposition => 'inline'
    end
   end
  end
  
  


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dailybank
      @dailybank = Dailybank.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dailybank_params
      params.require(:dailybank).permit(:user_id, :effective_date, :bacs, :till_cash, :till_float, :card_payments, :card_1, :card_2, :expenses_total, :actual_cash_total, :till_takings_check, :till_takings, :wet_takings, :dry_takings, :merch_takings, :vouchers_sold, :vouchers_used, :deposit_sold, :deposit_used, :actual_till_takings, :reported_till_takings, :v_d_adjustments, :total_eft_taken, :total_expected_cash, :terminal_1, :terminal_2, :tablet_1, :tablet_2, :calculated_variance, :user_variance, :variance_comment, :status, :variance_gap, :gratuity_1, :gratuity_2, :gratuity_total, :banking, :cashfloats_attributes => [:id, :dailybank_id, :float_type, :period, :completed_by, :user_code, :fifties, :twenties, :tens, :fives, :two_pound_single, :pound_single, :fifty_single, :twenty_single, :ten_single, :five_single, :two_single, :one_single, :float_actual, :float_target, :float_gap, :float_comment, :completed, :cheat, :override], :expenses_attributes => [:id, :dailybank_id, :what, :where, :price, :ref, :_destroy] )
    end
    
    def run_calc_rules(dailybank)
      #good
      if (!dailybank.till_float.blank? && !dailybank.till_cash.blank?)
        dailybank.update_attribute(:banking, (dailybank.till_cash-dailybank.till_float))
       end
     
       #good
       if (!dailybank.gratuity_1.blank? && !dailybank.gratuity_2.blank?)
         dailybank.update_attribute(:gratuity_total, (dailybank.gratuity_1+dailybank.gratuity_2))
       end
     
       #good
       if (!dailybank.card_1.blank? && !dailybank.card_2.blank?)
         dailybank.update_attribute(:card_payments, (dailybank.card_1+dailybank.card_2))
       end
      
      #good
      if (!dailybank.card_1.blank? && !dailybank.card_2.blank? && !dailybank.gratuity_2.blank? && !dailybank.gratuity_2.blank?)
        dailybank.update_attribute(:card_payments, ((dailybank.card_1+dailybank.card_2)-(dailybank.gratuity_1+dailybank.gratuity_2)))
      end
      
      #good
      # JIM changes
      if (!dailybank.banking.blank? && !dailybank.card_payments.blank? && !dailybank.expenses_total.blank? && !dailybank.bacs.blank?)
        dailybank.update_attribute(:actual_cash_total, (dailybank.banking+dailybank.card_payments+dailybank.expenses_total+dailybank.bacs))
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
      end 
       
      #good
      if (!dailybank.vouchers_sold.blank? && !dailybank.vouchers_used.blank? && !dailybank.deposit_sold.blank? && !dailybank.deposit_used.blank?)
         dailybank.update_attribute(:v_d_adjustments, ((dailybank.vouchers_sold+dailybank.deposit_sold)-(dailybank.deposit_used+dailybank.vouchers_used)))
        else
      end 
      
      #good
      if (!dailybank.v_d_adjustments.blank? && !dailybank.till_takings.blank?)
         dailybank.update_attribute(:actual_till_takings, (dailybank.till_takings+dailybank.v_d_adjustments))
        end 
      
      #good
      if (dailybank.expenses.any?)
         dailybank.update_attribute(:expenses_total, (dailybank.expenses.sum(:price)))
        end 
      
      #test
        if (!dailybank.actual_cash_total.blank? && !dailybank.actual_till_takings.blank?)
          dailybank.update_attribute(:calculated_variance, (dailybank.actual_cash_total-dailybank.actual_till_takings))
        end
        
        #test
        if (!dailybank.terminal_1.blank? && !dailybank.terminal_2.blank? && !dailybank.tablet_1.blank? && !dailybank.tablet_2.blank?)
          dailybank.update_attribute(:total_expected_cash, (dailybank.terminal_1+dailybank.terminal_2+dailybank.tablet_1+dailybank.tablet_2))
        end
      end
         
end
