class ExpensesController < ApplicationController
  before_action :set_expense, only: [:show, :edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all
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
    ep[:ref] = Expense.all.last.ref+1
   
    @expense = @dailybank.expenses.create(ep)
    redirect_to edit_dailybank_path(@dailybank)
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
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
    @dailybank = Dailybank.find(params[:dailybank_id])
     @expense = @dailybank.expenses.find(params[:id])
     @expense.destroy
      redirect_to edit_dailybank_path(@dailybank)
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
