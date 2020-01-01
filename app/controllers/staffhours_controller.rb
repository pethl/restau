class StaffhoursController < ApplicationController
#  before_action :set_staffhour, only: [:show, :edit, :update, :destroy]
before_action :logged_in_user, only: [:show, :edit, :update, :destroy, :index, :new, :edit_all, :show_team]

  # GET /staffhours
  # GET /staffhours.json
  def index
    @staffhours = Staffhour.all
    @staffhours = @staffhours.sort_by { |hsh| hsh[:staff_id] }
  end
  
  def accrued_vacation
    @table_dates=[]
      start_date = Date.today.beginning_of_year # Current vacation calendar year
      end_date = Date.today.end_of_year # Current vacation calendar year - end
      my_days = [0] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
      @table_dates = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday)} # populate table head
      
      @foh_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Front of House"}).where('week_end_date BETWEEN ? AND ?', start_date, end_date )
      @foh_staffhours = @foh_staffhours.sort_by { |hsh| hsh[:staff_id] }.group_by {|i| i.staff_id}
      
      @kit_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Kitchen"}).where('week_end_date BETWEEN ? AND ?', start_date, end_date )
      @kit_staffhours = @kit_staffhours.sort_by { |hsh| hsh[:staff_id] }.group_by {|i| i.staff_id}
  
  end
  

  # GET /staffhours
  # GET /staffhours.json
  def show_team
   if Accruel_rate.all.count == 0
   else
    @tronc_total = get_tronc_total_for_current_period
    @table_dates=[]
      start_date = get_tronc_start # Current period tronc start 
      end_date = get_tronc_end # Current period tronc end
      my_days = [0] # day of the week in 0-6. Sunday is day-of-week 0; Saturday is day-of-week 6.
      @table_dates = (start_date..end_date).to_a.select {|k| my_days.include?(k.wday)} # populate table head
      
      @pure_foh_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Front of House", payment_terms: "Hourly Rate", status: "Active"}).where('week_end_date BETWEEN ? AND ?', start_date, end_date )
      @foh_staffhours = @pure_foh_staffhours.sort_by { |hsh| hsh[:staff_id] }
      @foh_staffhours = @foh_staffhours.group_by {|i| i.staff_id}  # array grouped by staff member   
      @foh_staff =Staff.where(area: "Front of House", status: "Active", payment_terms: "Hourly Rate")
 
      @pure_kit_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Kitchen", payment_terms: "Hourly Rate", status: "Active"}).where('week_end_date BETWEEN ? AND ?', start_date, end_date )
      @kit_staffhours = @pure_kit_staffhours.sort_by { |hsh| hsh[:staff_id] }
      @kit_staffhours = @kit_staffhours.group_by {|i| i.staff_id}  # array grouped by staff member   
      @kit_staff =Staff.where(area: "Kitchen", status: "Active", payment_terms: "Hourly Rate")
      
      @mgrs =Staff.where(area: "Manager", status: "Active")
     
    end
    end

  # GET /staffhours/1
  # GET /staffhours/1.json
  def show
     @staffhour = Staffhour.find(params[:id])
  end

  # GET /staffhours/new
  def new
    @staffhour = Staffhour.new
  end

  # GET /staffhours/1/edit
  def edit
     @staffhour = Staffhour.find(params[:id])
  end

  # POST /staffhours
  # POST /staffhours.json
  def create
    @staffhour = Staffhour.new(staffhour_params)
    
    @accruel_rate = Accruel_rate.find(@staffhour.accruel_rate_id).rate
    @wk_accrued_hrs = @staffhour.hours *  @accruel_rate
    
    @staffhour.update(wk_accrued_hours: @wk_accrued_hrs)
    @staffhour.save!

    respond_to do |format|
      if @staffhour.save
        format.html { redirect_to @staffhour, notice: 'Staffhour was successfully created.' }
        format.json { render :show, status: :created, location: @staffhour }
      else
        format.html { render :new }
        format.json { render json: @staffhour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /staffhours/1
  # PATCH/PUT /staffhours/1.json
  def update
     @staffhour = Staffhour.find(params[:id])
     respond_to do |format|
      
     #  if @staffhour.update_attributes(params[:staffhour])
      if @staffhour.update(staffhour_params)
         format.html { redirect_to(@staffhour, :notice => 'Staff hours were successfully updated.') }
         format.xml  { head :ok }
       else
         format.html { render :action => "edit" }
         format.xml  { render :xml => @staffhour.errors, :status => :unprocessable_entity }
       end
     end
   end

  # DELETE /staffhours/1
  # DELETE /staffhours/1.json
  def destroy
    @staffhour = Staffhour.find(params[:id])
    
    @staffhour.destroy
    respond_to do |format|
      format.html { redirect_to staffhours_url, notice: 'Staffhour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  # GET /users/all/edit
  def edit_all
    @staffs = Staff.where(status: "Active", payment_terms: "Hourly Rate")
      if @staffs.any?
        ef = Date.today.end_of_week
        if get_staff_hours_for_date(ef).count <1
          generate_staffhours_by_date(ef, @staffs)
        end
        @staffhours = get_staff_hours_for_date(ef)
      end
      @staffhours = @staffhours.sort_by { |hsh| hsh[:staff_id] } 
  end
  
  # GET /users/all/edit
  def edit_last
    @staffs = Staff.where(status: "Active", payment_terms: "Hourly Rate")
      if @staffs.any?
        ef = Date.today.end_of_week-7.days
        if get_staff_hours_for_date(ef).count <1
          generate_staffhours_by_date(ef, @staffs)
        end
        @staffhours = get_staff_hours_for_date(ef)
      end
      @staffhours = @staffhours.sort_by { |hsh| hsh[:staff_id] } 
  end
  
  # GET /users/all/edit
  def edit_next
    @staffs = Staff.where(status: "Active", payment_terms: "Hourly Rate")
      if @staffs.any?
        ef = Date.today.end_of_week+7.days
        if get_staff_hours_for_date(ef).count <1
          generate_staffhours_by_date(ef, @staffs)
        end
        @staffhours = get_staff_hours_for_date(ef)
      end
      @staffhours = @staffhours.sort_by { |hsh| hsh[:staff_id] } 
  end

   # PUT /users/all
   def update_all
     params['staffhour'].keys.each do |id|
       @staffhour = Staffhour.find(id.to_i)
       @staffhour.update_attributes(staffhour_params_for_id(id))
     end
     redirect_to(show_team_url)
   end
   
   def staffhour_params_for_id(id)
     params.require(:staffhour).fetch(id).permit(:week_end_date, :staff_id, :hours, :wk_accrued_hours, :accruel_rate_id, :accruel_rate_attributes => [:id, :rate, :effective_date])
   end
   
   def download_vacation_accruel_report_pdf
     @start_date = Date.today.beginning_of_year # Current vacation calendar year
     @end_date = Date.today.end_of_year # Current vacation calendar year - end
     
     @foh_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Front of House"}).where('week_end_date BETWEEN ? AND ?', @start_date, @end_date )
     @foh_staffhours = @foh_staffhours.sort_by { |hsh| hsh[:staff_id] }.group_by {|i| i.staff_id}
     
     @kit_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Kitchen"}).where('week_end_date BETWEEN ? AND ?', @start_date, @end_date )
     @kit_staffhours = @kit_staffhours.sort_by { |hsh| hsh[:staff_id] }.group_by {|i| i.staff_id}
 
    
     respond_to do |format|
      format.pdf do
        #DOCUMENT SETUP_START
        pdf = Prawn::Document.new
        pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n", size: 6
        pdf.text "\n", size: 6  
        pdf.text "Vacation Accruel Report : " + @start_date.to_date.strftime('%d %b, %Y') + " - " + @end_date.to_date.strftime('%d %b, %Y'), size: 14, style: :bold
        pdf.text "Print Date: "+Date.today.to_s+"\n", size: 6
        pdf.text "\n", size: 6  
        #DOCUMENT SETUP_END  
      
        #FOH_SUMMARY_START
        pdf.text "Front of House", size: 10, style: :bold 
        
          foh_table_data = Array.new
          foh_table_data << ["Name","Accrued Hours"]
          @foh_staffhours.each do |staff, foh_hours|
       
          foh_table_data << [Staff.find(staff).name, foh_hours.map { |h| h[:wk_accrued_hours] }.compact.sum.to_d.to_s]
       end   
           pdf.table(foh_table_data) do 
             self.width = 150
             self.cell_style = { :inline_format => true, size: 6 } 
              row(0).font_style = :bold
             columns(0).width = 100
             columns(1).width = 50
             columns(0).align = :left
             columns(1).align = :right
             end
          
          pdf.text "\n", size: 6  
          pdf.text "\n", size: 6  
            
          #KITCHEN_SUMMARY_START
          pdf.text "Kitchen", size: 10, style: :bold 
        
            table_data = Array.new
            table_data << ["Name","Hours"]
            @kit_staffhours.each do |staff, kit_hours|
       
            table_data << [Staff.find(staff).name, kit_hours.map { |h| h[:wk_accrued_hours] }.compact.sum.to_s]
         end   
             pdf.table(table_data) do 
               self.width = 150 
               self.cell_style = { :inline_format => true, size: 6 } 
                row(0).font_style = :bold
               columns(0).width = 100
               columns(1).width = 50
               columns(0).align = :left
               columns(1).align = :right
              end
           send_data pdf.render, filename: 'vacation_accruel.pdf', type: 'application/pdf', :disposition => 'inline'
        end
      end
   end
   
   def download_tronc_allocation_report_pdf
     @start_date = params[:value]
     @end_date = get_tronc_end
     @tronc_total = get_tronc_total_for_current_period
     @foh_split=get_foh_split_of_tronc
     @kit_split=get_kitchen_split_of_tronc
     @card_split=get_card_split_of_tronc
     @mgr_split=get_mgr_split_of_tronc
     
     @pure_foh_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Front of House", payment_terms: "Hourly Rate", status: "Active"}).where('week_end_date BETWEEN ? AND ?', @start_date, @end_date )
     @foh_staffhours = @pure_foh_staffhours.sort_by { |hsh| hsh[:staff_id] }
     @foh_staffhours = @foh_staffhours.group_by {|i| i.staff_id}  # array grouped by staff member   
     @foh_staff =Staff.where(area: "Front of House", status: "Active", payment_terms: "Hourly Rate")

     @pure_kit_staffhours =Staffhour.joins(:staff).where(staffs: {area: "Kitchen", payment_terms: "Hourly Rate"}).where('week_end_date BETWEEN ? AND ?', @start_date, @end_date )
     @kit_staffhours = @pure_kit_staffhours.sort_by { |hsh| hsh[:staff_id] }
     @kit_staffhours = @kit_staffhours.group_by {|i| i.staff_id}  # array grouped by staff member  
     @kit_staff =Staff.where(area: "Kitchen", status: "Active", payment_terms: "Hourly Rate")
     
      @mgrs =Staff.where(area: "Manager", status: "Active")
  
  
     respond_to do |format|
      format.pdf do
        #DOCUMENT SETUP_START
        pdf = Prawn::Document.new
        pdf.text ":: HANG FIRE SOUTHERN KITCHEN :: The Pump House, Hood Road, Barry, CF62 5QN"+"\n", size: 6
        pdf.text "\n", size: 6  
        pdf.text "TRONC Allocation Report : " + @start_date.to_date.strftime('%d %b, %Y') + " - " + @end_date.to_date.strftime('%d %b, %Y'), size: 14, style: :bold
        pdf.text "\n", size: 6  
        pdf.text "TRONC Total : "+ "£#{(sprintf "%.2f",get_tronc_total_for_current_period)}"+"\n", size: 10 
        pdf.text "\n", size: 6  
        pdf.text "Splits", size: 8, style: :bold  
        pdf.text "Card Processing: "+ "£#{(sprintf "%.2f",@card_split)}"+",   "+get_card_percentage.to_s+"%"+"\n", size: 8 
        pdf.text "Managers: "+ "£#{(sprintf "%.2f",@mgr_split)}"+",   "+get_mgr_percentage.to_s+"%"+"\n", size: 8 
        pdf.text "FoH: "+ "£#{(sprintf "%.2f",@foh_split)}"+",   "+get_foh_percentage.to_s+"%"+",   "+get_foh_method+"\n", size: 8 
        pdf.text "Kitchen: "+ "£#{(sprintf "%.2f",@kit_split)}"+",   "+get_kitchen_percentage.to_s+"%"+",   "+get_kit_method+"\n", size: 8 
        pdf.text "\n", size: 6  
        #DOCUMENT SETUP_END  
      
        #MGR_SUMMARY_START------------------------MGR--------------------------------------------------------
        pdf.text "Managers", size: 8, style: :bold 
        
          mgr_table_data = Array.new
          mgr_table_data << ["Name", "TRONC"]
          @mgrs.each do |mgr|
       
          mgr_table_data << [Staff.find(mgr).name, "£#{(sprintf "%.2f",(get_each_mgr_share))}"]
         
       end   
           pdf.table(mgr_table_data) do 
             self.width = 150 
             self.cell_style = { :inline_format => true, size: 6 } 
              row(0).font_style = :bold
             columns(0).width = 100
             columns(1).width = 50
             columns(0).align = :left
             columns(1).align = :right
         end
          
          pdf.text "\n", size: 6  
          pdf.text "\n", size: 6  
      
        #FOH_SUMMARY_START------------------------------------FOH-----------------------------------------
        pdf.text "Front of House", size: 8, style: :bold 
        pdf.text "Count of Active - FOH - Hourly Rate Staff:  "+foh_count.to_s+"\n", size: 6
        
        if get_foh_method=="By Hours"
        
          foh_table_data = Array.new
          foh_table_data << ["Name","Hours", "TRONC"]
          @foh_staffhours.each do |staff, foh_hours|
       
          foh_table_data <<  [Staff.find(staff).name, foh_hours.map { |h| h[:hours] }.compact.sum.to_s, "£#{(sprintf "%.2f",(get_foh_staff_split_of_tronc(foh_hours,@pure_foh_staffhours)))}"]
       end   
           pdf.table(foh_table_data) do 
             self.width = 200 
             self.cell_style = { :inline_format => true, size: 6 } 
              row(0).font_style = :bold
             columns(0).width = 100
             columns(1..2).width = 50
             columns(0).align = :left
             columns(1).align = :right
              columns(2).align = :right
          end
          
        else
          foh_table_data = Array.new
          foh_table_data << ["Name", "TRONC"]
          @foh_staff.each do |staff|
       
          foh_table_data <<  [Staff.find(staff).name,  "£#{(sprintf "%.2f",(get_each_foh_share_even_split))}"]
       end   
           pdf.table(foh_table_data) do 
             self.width = 150 
             self.cell_style = { :inline_format => true, size: 6 } 
              row(0).font_style = :bold
             columns(0).width = 100
             columns(1).width = 50
             columns(0).align = :left
             columns(1).align = :right
          end
        end
          pdf.text "\n", size: 6  
          pdf.text "\n", size: 6  
            
          #KITCHEN_SUMMARY_START--------------------------KIT-------------------------------------
          pdf.text "Kitchen", size: 8, style: :bold 
          pdf.text "Count of Active - Kitchen - Hourly Rate Staff:  "+kit_count.to_s+"\n", size: 6
       
         if get_kit_method=="By Hours"
           
            table_data = Array.new
            table_data << ["Name","Hours", "TRONC"]
            @kit_staffhours.each do |staff, kit_hours|
       
            table_data << [Staff.find(staff).name, kit_hours.map { |h| h[:hours] }.compact.sum.to_s, "£#{(sprintf "%.2f",(get_kitchen_staff_split_of_tronc(kit_hours,@pure_kit_staffhours)))}"]
         end   
             pdf.table(table_data) do 
               self.width = 200 
               self.cell_style = { :inline_format => true, size: 6 } 
                row(0).font_style = :bold
               columns(0).width = 100
               columns(1..2).width = 50
               columns(0).align = :left
               columns(1).align = :right
               columns(2).align = :left
            end
            
          else
            kit_table_data = Array.new
            kit_table_data << ["Name", "TRONC"]
            @kit_staff.each do |staff|
       
            kit_table_data <<  [Staff.find(staff).name,  "£#{(sprintf "%.2f",(get_each_kit_share_even_split))}"]
         end   
             pdf.table(kit_table_data) do 
               self.width = 150 
               self.cell_style = { :inline_format => true, size: 6 } 
                row(0).font_style = :bold
               columns(0).width = 100
               columns(1).width = 50
               columns(0).align = :left
               columns(1).align = :right
            end
          end  
           send_data pdf.render, filename: 'tronc_allocation.pdf', type: 'application/pdf', :disposition => 'inline'
        end
      end
   end
   

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_staffhour
      @staffhour = Staffhour.find(params[:id])
    end

    def staffhour_params
      params.require(:staffhour).permit(:week_end_date, :staff_id, :hours, :wk_accrued_hours, :accruel_rate_id, :accruel_rate_attributes => [:id, :rate, :effective_date])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
  #  def staffhour_params
  #    params.require(:staffhour).permit(:week_end_date, :staff_id, :hours, :wk_accrued_hours, :accruel_rate_id, :accruel_rate_attributes => [:id, :rate, :effective_date])
  #  end
  
  def get_tronc_start
    Tronc.where(status: "Current").first.start_date
  end
  
  def get_tronc_end
    Tronc.where(status: "Current").first.end_date
  end
  
  def get_tronc_total_for_current_period
    @dailybanks= Dailybank.where('effective_date BETWEEN ? AND ?',get_tronc_start, get_tronc_end )
    @dailybanks.map { |h| h[:gratuity_total] }.compact.sum
  end
  
  def foh_count
    Staff.where(area: "Front of House", status: "Active", payment_terms: "Hourly Rate").count
  end
  
  def kit_count
    Staff.where(area: "Kitchen", status: "Active", payment_terms: "Hourly Rate").count
  end
  
  def mgr_count
    Staff.where(area: "Manager", status: "Active").count
  end
   
  def get_foh_split_of_tronc
     ((Tronc.where(status: "Current").first.foh_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_kitchen_split_of_tronc
     ((Tronc.where(status: "Current").first.kitchen_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_card_split_of_tronc
     ((Tronc.where(status: "Current").first.card_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_mgr_split_of_tronc
     ((Tronc.where(status: "Current").first.mgr_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_foh_percentage
     (Tronc.where(status: "Current").first.foh_split)
  end
  
  def get_kitchen_percentage
     (Tronc.where(status: "Current").first.kitchen_split) 
  end
 
  def get_card_percentage
     (Tronc.where(status: "Current").first.card_split)
  end
  
  def get_mgr_percentage
     (Tronc.where(status: "Current").first.mgr_split) 
  end
  
  def get_foh_method
     (Tronc.where(status: "Current").first.foh_method)
  end
  
  def get_kit_method
     (Tronc.where(status: "Current").first.kit_method) 
  end
 
  
  def get_foh_staff_split_of_tronc(foh_hours,pure_foh_staffhours)
    ((foh_hours.map { |h| h[:hours] }.compact.sum)/(pure_foh_staffhours.map { |h| h[:hours] }.compact.sum))*get_foh_split_of_tronc
  end
  
  def get_kitchen_staff_split_of_tronc(kit_hours,pure_kit_staffhours)
    ((kit_hours.map { |h| h[:hours] }.compact.sum)/(pure_kit_staffhours.map { |h| h[:hours] }.compact.sum))*get_kitchen_split_of_tronc
  end
  
  def get_staff_hours_for_date(date)
     ar = Accruel_rate.last.id
     Staffhour.where(week_end_date: date, accruel_rate_id: ar) 
   end
   
   def generate_staffhours_by_date(date, staffs)
      ar = Accruel_rate.last.id
     @staffhours=[]
       staffs.each do |staff|
          sh = Staffhour.create(week_end_date: date, staff_id: staff.id, accruel_rate_id: ar, hours: 0)
        end
    end
    
  def get_each_mgr_share
       get_mgr_split_of_tronc/mgr_count
  end
  
  def get_each_foh_share_even_split
       get_foh_split_of_tronc/foh_count
  end
  
  def get_each_kit_share_even_split
       get_kitchen_split_of_tronc/kit_count
  end
end
