desc "This task is called by the Heroku scheduler add-on"
  
task :purge_held_bookings => :environment do
   puts "PURGE_HELD_BOOKINGS_____START:Purge held bookings created yesterday."
   puts "PURGE_HELD_BOOKINGS_____BEFORE_CHECK:Records to be purged - count #{Booking.where("created_at < ? AND status = ?",Date.yesterday.end_of_day, "Held").count}" 
   puts "PURGE_HELD_BOOKINGS_____RUN_TASK:Purging held bookings created yesterday..."
   Booking.where("created_at < ? AND status = ?", Date.yesterday.end_of_day, "Held").destroy_all
   puts "PURGE_HELD_BOOKINGS_____AFTER_CHECK:Records to be purged - count #{Booking.where("created_at < ? AND status = ?",Date.yesterday.end_of_day, "Held").count}" 
   puts "PURGE_HELD_BOOKINGS_____END:Held bookings created yesterday have been purged"
 end
 
 
 task :test_reminder => :environment do
    puts "SEND_BOOKING_REMINDER_____START:Send a booking reminder email to everyone with a booking tomorrow."
    puts "SEND_BOOKING_REMINDER_____BEFORE_CHECK:Booking records requiring reminder - count #{Booking.where("booking_date_time BETWEEN ? AND ?", Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day).where("status = ?", "Confirmed").count}" 
    puts "SEND_BOOKING_REMINDER_____RUN_TASK:Purging held bookings created yesterday..."
    puts "SEND_BOOKING_REMINDER______USER: #{Booking.find(2361).email}"
    BookingMailer.booking_reminder_customer(Booking.find(2361)).deliver_now
    puts "SEND_BOOKING_REMINDER_____AFTER_CHECK:Reminders send - count"  
    puts "SEND_BOOKING_REMINDER_____END:Customer booking reminders for tomorrow have been sent"
  end 