class FunctionsController < ApplicationController
  before_action :set_function, only: [:show, :edit, :update, :destroy]

  # GET /functions
  # GET /functions.json
  def index
    @functions = Function.all
  end

  # GET /functions/1
  # GET /functions/1.json
  def show
  end

  # GET /functions/new
  def new
    @function = Function.new
  end

  # GET /functions/1/edit
  def edit
  end

  # POST /functions
  # POST /functions.json
  def create
    @function = Function.new(function_params)

      if @function.save
        FunctionMailer.send_function_enquiry(@function).deliver_now
        redirect_to @function, notice: 'Your enquiry has been sent! Thank you for contacting Hang Fire.' 
            else
              render 'static_pages/function_room_enquiry'
      #  redirect => "static_pages/function_room_enquiry", collection:  @function
       #  redirect_to controller: 'static_pages', action: 'function_room_enquiry', collection: @function
       # render 'static_pages/function_room_enquiry'
      
    end
  end

  # PATCH/PUT /functions/1
  # PATCH/PUT /functions/1.json
  def update
    respond_to do |format|
      if @function.update(function_params)
        format.html { redirect_to @function, notice: 'Function was successfully updated.' }
        format.json { render :show, status: :ok, location: @function }
      else
        format.html { render :edit }
        format.json { render json: @function.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /functions/1
  # DELETE /functions/1.json
  def destroy
    @function.destroy
    respond_to do |format|
      format.html { redirect_to functions_url, notice: 'Function was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_function
      @function = Function.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def function_params
      params.require(:function).permit(:status, :event_date, :est_party_size, :party_size, :customer_name, :phone, :email, :message, :event_type, :est_time, :event_start_time, :event_end_time, :deposit_amount, :deposit_paid, :t_and_c_signed, :menu_choice)
    end
end
