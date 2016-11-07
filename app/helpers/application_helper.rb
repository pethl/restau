module ApplicationHelper
  
  def number_to_currency(number, options = {})
    options[:locale] ||= I18n.locale
    super(number, options)
  end
  
  def restaurant_count(account_id)
    Restaurant.where(:account_id => account_id).count
  end
  
  def table_count(restaurant_id)
    Table.where(:restaurant_id => restaurant_id).count
  end
  
  def max_diners_at_current_time(restaurant_id)
    Rdetail.where(:restaurant_id => restaurant_id)[0].max_diners_at_current_time
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

end
