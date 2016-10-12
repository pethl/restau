module BookingsHelper
  
  def booking_completed_raw
    Booking.where("booking_date_time < ?", Date.yesterday.end_of_day).where(:status => "Confirmed")
  end
  
  def booking_outstanding_raw
    Booking.where("booking_date_time > ?", Date.yesterday.end_of_day).where(:status => "Confirmed")
  end
  
  def booking_made_on_this_day(date)
    Booking.where("created_at BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where(:status => "Confirmed").count
  end
  
  def booking_made_in_this_week(date)
    Booking.where("created_at BETWEEN ? AND ?", date.beginning_of_week.beginning_of_day, date.end_of_week.end_of_day).where(:status => "Confirmed").count
  end
  
  def booking_made_in_this_month(date)
    Booking.where("created_at BETWEEN ? AND ?", date.beginning_of_month.beginning_of_day, date.end_of_month.end_of_day).where(:status => "Confirmed").count
  end
  
  def booking_all_confirmed
    Booking.where(:status => "Confirmed").count
  end
  
  def booking_all_confirmed_raw
    Booking.where(:status => "Confirmed")
  end

  def booking_cancelled_on_this_day(date)
    Booking.where("cancelled_at BETWEEN ? AND ?", date.beginning_of_day.beginning_of_day, date.end_of_day.end_of_day).where(:status => "Cancelled").count
  end
  
  def booking_cancelled_in_this_week(date)
    Booking.where("cancelled_at BETWEEN ? AND ?", date.beginning_of_week.beginning_of_day, date.end_of_week.end_of_day).where(:status => "Cancelled").count
  end
  
  def booking_cancelled_in_this_month(date)
    Booking.where("cancelled_at BETWEEN ? AND ?", date.beginning_of_month.beginning_of_day, date.end_of_month.end_of_day).where(:status => "Cancelled").count
  end
  
  def booking_people_count_by_day
    @start_date = Date.new(2016,03,04)
    @end_date = Date.today+6.month
    i = @start_date
    @array = []
    
     while i != @end_date do
       @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", i.beginning_of_day, i.end_of_day).where("status = ?", "Confirmed")
       people = get_sum_from_array_for_field(@bookings)
       @array += [[i.strftime('%Y-%m-%d'), people]]
       i = i+1.day
     end
     return @array
  end
  
  
  def booking_count_by_day(date)
    i = 0
    array = []
    loop do
      array[i] = [date, (Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where(:status => "Confirmed").count)]
      i = i+1
      date = date+1.day
      break if i == 20
    end
    return array
  end
  
  def get_float_time(time)
    hour = time.hour
    min = time.min
    float_time = hour.to_s + "." + min.to_s
    float_time = float_time.to_f
    return float_time
  end
  
  def has_booking(booking_time, hr, min, number_of_diners) 
    
    if number_of_diners >8
      time = 165
    elsif number_of_diners >5
      time = 135
    else
      time = 105
    end
    
    booking_start = get_float_time(booking_time) #response is formatted as float
    booking_end = get_float_time(booking_time + (time.minutes))  #response is formatted as float
    period_start = (hr.to_s + "." + min.to_s).to_f
    
  if (booking_start..booking_end).include?(period_start) 
    answer = [2, number_of_diners] 
    return answer
  else
      return false 
    end
  
  end  
  

  
  def reformat_bookings_into_single_line(one_days_booking_grouped_by_table)
    @result = Hash.new #this is the final hash we will return containing one hash per table for display
    
    bookings_per_table = one_days_booking_grouped_by_table # does nothing just simpler name
    
    bookings_per_table.sort_by(&:first).each do |table, bookings| #take each set from hash, a table and its bookings
      #go through each booking and match the booking_time to a period_start
    
      #this hash contains all the time period slots we need to match to  
      table_hash = { 10.0 => 0, 10.3 => 0, 11.0 => 0, 11.3 => 0, 12.0 => 0, 12.3 => 0, 13.0 => 0, 13.3 => 0, 14.0 => 0, 14.3 => 0, 15.0 => 0, 15.3 => 0, 16.0 => 0, 16.3 => 0, 17.0 => 0, 17.3 => 0, 18.0 => 0, 18.3 => 0, 19.0 => 0, 19.3 => 0, 20.0 => 0, 20.3 => 0, 21.0 => 0, 21.3 => 0, 22.0 => 0, 22.3 => 0, 23.0 => 0, 23.3 => 0 }
    
      bookings.each do |booking| 
        booking_start = get_float_time(booking.booking_date_time) #response is formatted as float
        booking_end = get_float_time(booking.booking_date_time + (1.hour + 59.minutes))  #response is formatted as float
        
        table_hash.each do |key, value|
            if (booking_start..booking_end).include?(key) 
              table_hash[key] = [1, booking.id, booking.name] 
  #              table_hash[key] << booking.id 
            end
            if booking_start == key
              table_hash[key] = [2, booking.number_of_diners, booking.name] 
            end
           
        end
       
      end
      #before the end of this segment, we commit the table_hash to result hash using the table ID as key
 
      @result[table] = table_hash
    end
    return @result
  end
  
  def get_sum_from_array_for_field(records)
    @records = records
    the_sum = @records.to_a.sum do |record|
            record.number_of_diners
          end
    return the_sum
  end
  
  def get_sum_from_array_for_field_lunch(records)
    @records = records
     
    @records_lunch = []
    @records.each do |record|
      if record.booking_date_time < @records.first.booking_date_time.change({ hour: 16, min: 10 })
         @records_lunch << record
       end
    end
     
    the_sum = @records_lunch.to_a.sum do |record_lunch|
            record_lunch.number_of_diners
          end
    return the_sum
  end
  
  def get_sum_from_array_for_field_evening(records)
    @records = records
    
    @records_evening = []
    @records.each do |record|
      if record.booking_date_time > @records.first.booking_date_time.change({ hour: 16, min: 10 })
         @records_evening << record
       end
    end
     
    the_sum = @records_evening.to_a.sum do |record_evening|
            record_evening.number_of_diners
          end
    return the_sum
  end
  
  # TOTAL DINERS COUNT FOR CURRENT TIME (no of diners arriving at this moment+15 mins to start reservation)
  # this function is used on the staff booking by day pages - 3 variants midweek, fri/sat, sunday
  def get_total_diners_for_current_time(date_and_time)
  @diners_at_same_start_time = 0
  @bookings_at_same_start_time = []

  @bookings_at_same_start_time = Booking.where("booking_date_time BETWEEN ? AND ?", date_and_time,(date_and_time+15.minutes)).where(:status => "Confirmed")
  @diners_at_same_start_time = @bookings_at_same_start_time.to_a.sum do |booking_at_same_start_time|
          booking_at_same_start_time.number_of_diners
        end
        return @diners_at_same_start_time
  end
  
    # THIS FUNCTION RETURNS ALL BOOKINGS OF 7 OR OVER AS DELIMITED CHAR STRING, i.e. 7-9-10-8
    def get_bookings_over_seven(one_day_of_bookings)
      @bookings = one_day_of_bookings
      return_string = "-"
      find_values = [7,8,9,10]
      
      @bookings.each do |booking|
        if find_values.include?(booking.number_of_diners)
          return_string = return_string+booking.number_of_diners.to_s+"-"
        end
      end
       return return_string
    end
    
    # THIS FUNCTION RETURNS ALL BOOKINGS OF 7 OR OVER AS an array
    def get_bookings_over_seven_array(one_day_of_bookings)
      @bookings = one_day_of_bookings
      return_string = []
      find_values = [7,8,9,10]
      
      @bookings.each do |booking|
        if find_values.include?(booking.number_of_diners)
          return_string << booking.number_of_diners
        end
      end
       return return_string
    end
    
    # THIS FUNCTION RETURNS TRUE IF A DATE HAS A BOOKING OF 9  OR MORE
    def has_bookings_over_nine(one_day_of_bookings)
      @bookings = one_day_of_bookings
      @return_string= false
      find_values = [9,10]
      
      @bookings.each do |booking|
        if find_values.include?(booking.number_of_diners)
          @return_string= true
        else
          @return_string= false
        end
      end
       return @return_string
    end
    
    # THIS FUNCTION FINDS AVAILABLE SPACES PER DAY, BUT ALSO CHECKS AGAINST 10,9,8,7 LIMITS TO PREVENT SHOWING CUSTOMERS SPACES THEY CANNOT BOOK
    def get_available_space_sunday(bookings_by_day)
      @bookings = bookings_by_day
      return_hash = Hash.new
      hash_of_times=[[12,00],[12,30],[13,00],[13,30],[14,00],[14,30],[15,00]]
      hash_of_times.each do |time|
      booking = @bookings.first.booking_date_time.change({ hour: time.first, min: time.second })
        
        if get_total_diners_for_current_time(booking) < max_diners_at_current_time(@bookings.first[:restaurant_id])
         return_hash[booking.strftime("%H:%M")]= (max_diners_at_current_time(@bookings.first[:restaurant_id])- (get_total_diners_for_current_time(booking)))
        else
        end  
      end
      return return_hash
    end
    
    # THIS FUNCTION FINDS AVAILABLE SPACES PER DAY, BUT ALSO CHECKS AGAINST 10,9,8,7 LIMITS TO PREVENT SHOWING CUSTOMERS SPACES THEY CANNOT BOOK
    def get_available_space_sunday_adjusted(bookings_by_day)
      @bookings = bookings_by_day
      return_hash = Hash.new
      hash_of_times=[[12,00],[12,30],[13,00],[13,30],[14,00],[14,30],[15,00]]
      hash_of_times.each do |time|
      booking = @bookings.first.booking_date_time.change({ hour: time.first, min: time.second })
      current_big_tables = get_bookings_over_seven_array(@bookings)
        
        if get_total_diners_for_current_time(booking) < max_diners_at_current_time(@bookings.first[:restaurant_id])
          unless ((max_diners_at_current_time(@bookings.first[:restaurant_id])-2)- (get_total_diners_for_current_time(booking)))<= 0
            
         return_hash[booking.strftime("%H:%M")]= (((max_diners_at_current_time(@bookings.first[:restaurant_id]))- (get_total_diners_for_current_time(booking)))-2)
       end
        else
        end  
      end
      return return_hash
   end
   
  
end
