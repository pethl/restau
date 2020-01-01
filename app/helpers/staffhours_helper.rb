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
  
  def get_card_split
     Tronc.where(status: "Current").first.card_split
  end
  
  def get_mgr_split
     Tronc.where(status: "Current").first.mgr_split
  end
  
  def get_foh_split
     Tronc.where(status: "Current").first.foh_split
  end
  
  def get_kitchen_split
     Tronc.where(status: "Current").first.kitchen_split
  end
  
  def get_foh_method
     Tronc.where(status: "Current").first.foh_method
  end
  
  def get_kit_method
     Tronc.where(status: "Current").first.kit_method
  end
  
  def get_card_split_of_tronc
     ((Tronc.where(status: "Current").first.card_split)/100) *get_tronc_total_for_current_period 
  end
  
  def get_mgr_split_of_tronc
     ((Tronc.where(status: "Current").first.mgr_split)/100) *get_tronc_total_for_current_period 
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
  
  def get_foh_hourly_count
     Staff.where('status = ?', 'Active').where('payment_terms = ?', 'Hourly Rate').where('area = ?', 'Front of House').count
  end
  
  def get_kit_hourly_count
     Staff.where('status = ?', 'Active').where('payment_terms = ?', 'Hourly Rate').where('area = ?', 'Kitchen').count
  end
  
  def get_mgr_count
     Staff.where('status = ?', 'Active').where('area = ?', 'Manager').count
  end
  
end
