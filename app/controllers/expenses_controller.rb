class ExpensesController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index]
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = []
     @expenses_by_dailybank = []
      #take params from search on Index view, or if no search, return 0
      #send to model to apply SEARCH function, which retrieves matching records 
       if params[:from]
         @dailybanks = Dailybank.search(params)
               if @dailybanks.any?
                 @dailybank_ids = @dailybanks.map { |x| x[:id] }
                 # params= []
                 @expenses = Expense.where(:dailybank_id => @dailybank_ids) 
                 @expenses_by_dailybank = @expenses.group_by { |t| t.dailybank_id }
                 return  @expenses_by_dailybank
                else
                 params= []
                 @expenses = 1
               end
       else
         @expenses = 0
         params= []
       end
    
  end
  
  def show_many
   # Rails.logger.debug("XXXXXXXXX in show_many: #{params.inspect}")
    @expense = Expense.find(params[:id])
     @dailybank = Dailybank.find(@expense.dailybank_id)
     @expenses = Expense.where(:dailybank_id => @dailybank.id) 
     @expenses = @expenses.sort_by { |hsh| hsh[:ref] } 
     return @expenses
  end
  
  def add_new
   # Rails.logger.debug("\nXXXXXXXXX in add_new: #{params.inspect}")
     @dailybank = Dailybank.find(params[:id])
   #Rails.logger.debug("\nXXXXXXXXX in @dailybank: #{@dailybank.inspect}")
     ref = Expense.all.last.ref+1.to_i
     @expense = Expense.create(:dailybank_id => @dailybank.id, :ref => ref, :what => "what", :where => "where", :price => 0)
    #Rails.logger.debug("\nXXXXXXXXX in @expense: #{@expense.inspect}")
     redirect_to edit_expense_path(id: @expense.id)
  end
  
  def search
       @expenses = []
         #take params from search on Index view, or if no search, return 0
         #send to model to apply SEARCH function, which retrieves matching records 
          if params[:from]
            @dailybanks = Dailybank.search(params)
                  if @dailybanks.any?
                    # params= []
                    @expenses = @dailybanks.expenses
                   else
                    params= []
                    @expenses = 1
                  end
          else
            @expenses = 0
            params= []
          end
   
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @dailybank = Dailybank.find(params[:dailybank_id])
    ep= expense_params
    #THIS LINE OF CODE CANNOT BE SCALED UP TO MULTIPLE USERS _ NEEDS REWRITE
        if Expense.all.count ==0 
          ep[:ref] = 1001
        else
        ep[:ref] = Expense.all.last.ref+1
       end
    @expense = @dailybank.expenses.create(ep)
    redirect_to edit_dailybank_path(@dailybank)
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      
      if @expense.update(expense_params)
        format.html { redirect_to show_many_expenses_path(:id =>@expense.id), notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
   
    if params.has_key?(:dailybank_id)
      @dailybank = Dailybank.find(params[:dailybank_id])
      #count = @dailybank.expenses.count
      @expense = @dailybank.expenses.find(params[:id])
      @expense.destroy
       redirect_to edit_dailybank_path(@dailybank)
    else
      @expense = Expense.find(params[:id])
      @@dailybank = Dailybank.where(:id => @expense.dailybank_id)
      Rails.logger.debug("\nXXXXXXXXX in else: #{ @@dailybank.inspect}")
      @expense.destroy
      count = Expense.where(:dailybank_id => @expense.dailybank_id).count
      if count > 0
        remaining_expense_id = Expense.where(:dailybank_id => @expense.dailybank_id).first.id
       redirect_to show_many_expenses_path(:id => remaining_expense_id), notice: 'Expense was successfully destroyed' 
     else
       if @@dailybank[0].status == "Validate and Lock"
         redirect_to edit_dailybank_path(:id => @@dailybank[0].id), notice: 'Expense was successfully destroyed' 
       elsif (@@dailybank[0].status == "Mgmt Review") || (@@dailybank[0].status == "Mgmt re-calc")
         redirect_to mgmt_review_dailybank_path(:id => @@dailybank[0].id), notice: 'Expense was successfully destroyed' 
       end
     end
    end  
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      params.require(:expense).permit(:dailybank_id, :what, :where, :price, :price, :ref)
    end
end
