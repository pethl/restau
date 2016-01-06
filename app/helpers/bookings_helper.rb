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
  
  def reformat_bookings_into_single_line(one_days_booking_grouped_by_table)
    @result = Hash.new #this is the final hash we will return containing one hash per table for display
    
    bookings_per_table = one_days_booking_grouped_by_table # does nothing just simpler name
    
    bookings_per_table.each do |table, bookings| #take each set from hash, a table and its bookings
      #go through each booking and match the booking_time to a period_start
     Rails.logger.debug("table: #{table}")
      #this hash contains all the time period slots we need to match to  
      table_hash = { 11.0 => 0, 11.3 => 0, 12.0 => 0, 12.3 => 0, 13.0 => 0, 13.3 => 0, 14.0 => 0, 14.3 => 0, 15.0 => 0, 15.3 => 0, 16.0 => 0, 16.3 => 0, 17.0 => 0, 17.3 => 0, 18.0 => 0, 18.3 => 0, 19.0 => 0, 19.3 => 0, 20.0 => 0, 20.3 => 0, 21.0 => 0, 21.3 => 0, 22.0 => 0, 22.3 => 0, 23.0 => 0, 23.3 => 0, 24.0 => 0 }
    
      bookings.each do |booking| 
        
        booking_start = get_float_time(booking.booking_time) #response is formatted as float
        booking_end = get_float_time(booking.booking_time + (1.hour + 59.minutes))  #response is formatted as float
        
        table_hash.each do |key, value|
            if (booking_start..booking_end).include?(key) 
              table_hash[key] = 1   
            end
            if booking_start == key
              table_hash[key] = 2 
            end
        end
       
      end
      #before the end of this segment, we commit the table_hash to result hash using the table ID as key
 
      @result[table] = table_hash
    end
    return @result
  end
  
end
