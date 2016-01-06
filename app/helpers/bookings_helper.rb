module BookingsHelper
  
  def has_booking(booking_time, hr, min)
    
    booking_start = get_float_time(booking_time) #response is formatted as float
    booking_end = get_float_time(booking_time + (1.hour + 59.minutes))  #response is formatted as float
    booking_midway1 = get_float_time(booking_time + (29.minutes))  #response is formatted as float
    booking_midway2 = get_float_time(booking_time + (59.minutes))  #response is formatted as float
    booking_midway3 = get_float_time(booking_time + (79.minutes))  #response is formatted as float
    period_start = (hr.to_s + "." + min.to_s).to_f
    period_end = (hr.to_s + "." + (min+29).to_s).to_f
    
  if (booking_start..booking_end).include?(period_start) 
    return true
  else
     Rails.logger.debug("false: ")
      return false 
    end
  
  end  
  
  def get_float_time(time)
    hour = time.hour
    min = time.min
    float_time = hour.to_s + "." + min.to_s
    float_time = float_time.to_f
    return float_time
  end
  
end
