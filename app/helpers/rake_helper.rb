module RakeHelper
  
  
  def get_action_date_for_stats_and_purge
    if Dailystat.all.count == 0 
      return Date.new(2016,3,4)
    else Dailystat.last.action_date+1.day
    end 
  end
  
  def get_confirmed_bookings_by_date(date)
    Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where(:status => "Confirmed")
  end
  
  def get_cancelled_bookings_by_date(date)
    Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where(:status => "Cancelled")
  end
  
  def get_sum_from_array_for_field(records)
    @records = records
    the_sum = @records.to_a.sum do |record|
            record.number_of_diners
          end
    return the_sum
  end
  
 def avg_days_between_booking_made_and_taken(hash_of_bookings)
    the_days_array=[]
     hash_of_bookings.each do |booking|
          the_days_array << (booking.booking_date_time.to_date-booking.created_at.to_date).to_f
         end
   return (the_days_array.sum / the_days_array.size.to_f) 
 end
 
 def avg_days_between_booking_made_and_taken_over_6(hash_of_bookings)
    the_days_array=[]
     hash_of_bookings.each do |booking|
       if booking.number_of_diners > 6
          the_days_array << (booking.booking_date_time.to_date-booking.created_at.to_date).to_f
        end
         end
         if the_days_array.size > 0
   return (the_days_array.sum / the_days_array.size.to_f) 
 else
   return "N/A"
 end
 end
 
 def avg_days_between_booking_made_and_taken_under_7(hash_of_bookings)
    the_days_array=[]
     hash_of_bookings.each do |booking|
       if booking.number_of_diners < 7
          the_days_array << (booking.booking_date_time.to_date-booking.created_at.to_date).to_f
        end
         end
         if the_days_array.size > 0
   return (the_days_array.sum / the_days_array.size.to_f) 
 else
   return "N/A"
 end
 end
 
 def in_which_day_segement_was_booking_made(hash_of_bookings)
   dawn = 0
   early = 0
   lunch = 0
   afternoon = 0
   hometime = 0
   evening = 0
   
   hash_of_bookings.each do |booking|
     case booking.created_at.hour.to_i
       when 0,1,2,3,4
         dawn += 1
       when 5,6,7,8,9
         early += 1
       when 10,11,12,13
         lunch += 1
       when 14,15,16,17
         afternoon += 1
       when 18,19,20
         hometime += 1
       when 21,22,23,24
         evening += 1     
       else
       end
    end
    return_hash = {:dawn => dawn, :early => early, :lunch => lunch, :afternoon => afternoon, :hometime => hometime, :evening => evening}
    return return_hash
 end
 
 def in_which_hour_segement_was_booking(hash_of_bookings)
   early_lunch = 0
   late_lunch = 0
   early_eve = 0
   late_eve = 0
    
   hash_of_bookings.each do |booking|
     case booking.booking_date_time.hour.to_i
       when 12,13
         early_lunch += 1
       when 14,15,16
         late_lunch += 1
       when 17,18,19
         early_eve += 1
       when 20,21,22
         late_eve += 1
       else
       end
    end
    return_hash = {:early_lunch => early_lunch, :late_lunch => late_lunch, :early_eve => early_eve, :late_eve => late_eve}
    return return_hash
 end
 
 def write_stats
   date = get_action_date_for_stats_and_purge
   confirmed_bookings = get_confirmed_bookings_by_date(date)
   when_booking = in_which_day_segement_was_booking_made(confirmed_bookings)
   when_eating = in_which_hour_segement_was_booking(confirmed_bookings)
   
   if confirmed_bookings.count > 0
     @dailystat = Dailystat.new(action_date: date, cancelled_bookings: get_cancelled_bookings_by_date(date).count, confirmed_bookings: confirmed_bookings.count, diners_fed: get_sum_from_array_for_field(confirmed_bookings), avg_headcount_per_booking: @day_confirmed.average(:number_of_diners), avg_days_prior_to_booking:avg_days_between_booking_made_and_taken(confirmed_bookings), avg_days_prior_to_booking_under_seven:avg_days_between_booking_made_and_taken_under_7(confirmed_bookings), avg_days_prior_to_booking_over_six:avg_days_between_booking_made_and_taken_over_6(confirmed_bookings), dawn:when_booking[:dawn], early:when_booking[:early], lunch:when_booking[:lunch], afternoon:when_booking[:afternoon], hometime:when_booking[:hometime], evening:when_booking[:evening], early_lunch:when_eating[:early_lunch], late_lunch:when_eating[:late_lunch], early_eve:when_eating[:early_eve], late_eve:when_eating[:late_eve]).save
   else
     Dailystat.new(action_date: date).save
   end
 end
 

end
