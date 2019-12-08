class StaffeventsController < ApplicationController
  before_action :set_staffevent, only: [:show, :edit, :update, :destroy]

  # GET /staffevents
  # GET /staffevents.json
  def index
    @staffevents = Staffevent.all
  end

  # GET /staffevents/1
  # GET /staffevents/1.json
  def show
  end

  # GET /staffevents/new
  def new
    @staffevent = Staffevent.new
  end

  # GET /staffevents/1/edit
  def edit
  end

  # POST /staffevents
  # POST /staffevents.json
  def create
    @staff = Staff.find(params[:staff_id])
  #   @staffevent = @staff.staffevents.create(params[:staffevent])
      @staffevent = @staff.staffevents.new(staffevent_params)
  #    @error = Error.new(error_params)
     
  #  @staffevent = Staffevent.new(staffevent_params)

    respond_to do |format|
      if @staffevent.save
        format.html { redirect_to @staff, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @staffevent }
      else
        format.html { redirect_to @staff, notice: 'Event failed.'  }
       
      end
    end
  end

  # PATCH/PUT /staffevents/1
  # PATCH/PUT /staffevents/1.json
  def update
    respond_to do |format|
      if @staffevent.update(staffevent_params)
        format.html { redirect_to @staffevent, notice: 'Staffevent was successfully updated.' }
        format.json { render :show, status: :ok, location: @staffevent }
      else
        format.html { render :edit }
        format.json { render json: @staffevent.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /staffevents/1
  # DELETE /staffevents/1.json
 # def destroy
#    @staffevent.destroy
#    respond_to do |format|
#      format.html { redirect_to staffevents_url, notice: 'Staffevent was successfully destroyed.' }
#      format.json { head :no_content }
#    end
#  end
  
  def destroy
    @staff = Staff.find(params[:staff_id])
    @staffevent = @staff.staffevents.find(params[:id])
    @staffevent.destroy
    redirect_to staff_path(@staff)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffevent
      @staffevent = Staffevent.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def staffevent_params
      params.require(:staffevent).permit(:staff_id, :event_date, :event_reason, :event_notes)
    end
end
