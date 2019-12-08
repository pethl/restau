module StaffhoursHelper
  
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
  
  def get_foh_split
     Tronc.where(status: "Current").first.foh_split
  end
  
  def get_kitchen_split
     Tronc.where(status: "Current").first.kitchen_split
  end
  
  def get_foh_split_of_tronc
     ((Tronc.where(status: "Current").first.foh_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_kitchen_split_of_tronc
     ((Tronc.where(status: "Current").first.kitchen_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_total_hours(param)
    param.map { |h| h[:hours] }.compact.sum
  end
  
end
