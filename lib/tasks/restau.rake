namespace :restau do
  
  task purge_held_bookings: :environment do
    puts "\n"
     puts "----------------------PURGE_HELD_BOOKINGS:START-------------------------"
     log = ActiveSupport::Logger.new('log/purge_held_bookings.log')
         start_time = Time.now
         log.info "-----------Started at #{start_time}---------------------"
     
     puts "Purge held bookings created yesterday."
     bookings_count = Booking.where("created_at < ? AND status = ?",Date.yesterday.end_of_day, "Held").count
     puts "Records to be purged - count: #{bookings_count}" 
         log.info "Records to be purged = #{bookings_count}"
         
     Booking.where("created_at < ? AND status = ?", Date.yesterday.end_of_day, "Held").destroy_all
     check_count = Booking.where("created_at < ? AND status = ?",Date.yesterday.end_of_day, "Held").count
     puts "Check count - should be zero: #{check_count}" 
         log.info "Records to be purged = #{check_count}"
     puts "Held bookings created yesterday have been purged"
     
     end_time = Time.now
         duration = (start_time - end_time) / 1.minute
         log.info "Task lasted #{duration} minutes."
         log.info "-----------Finished at #{end_time}---------------------"
         log.info "\n"  
         log.close
      puts "----------------------PURGE_HELD_BOOOKINGS:END-------------------------"
     puts "\n"
   end
   
   task :send_booking_reminder => :environment do
     puts "\n"
      puts "----------------------SEND_BOOKING_REMINDER:START-------------------------"
      
      log = ActiveSupport::Logger.new('log/send_booking_reminder.log')
          start_time = Time.now
          log.info "-----------Started at #{start_time}---------------------"
      
      puts "_____Send a booking reminder email to everyone with a booking tomorrow+2.day."
      date = Date.tomorrow+2.day
          log.info "Booking reminders date #{date}"
          
      @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where("status = ?", "Confirmed")
      reminders_count = @bookings.count
      puts "_____Booking records requiring reminder - count #{reminders_count}" 
      
      if reminders_count > 0
      @bookings.each.with_index(1) do |booking, index|
              log.info "#{index}/#{reminders_count} - #{booking.booking_date_time.to_time} - #{booking.number_of_diners}"
          end
        end
      
      puts "_____Customer booking reminders for tomorrow have been sent"
      end_time = Time.now
          duration = (start_time - end_time) / 1.minute
          log.info "Task lasted #{duration} minutes."
          log.info "-----------Finished at #{end_time}---------------------"
          log.info "\n"  
          log.close
       puts "----------------------SEND_BOOKING_REMINDER:END-------------------------"
      puts "\n"
    end 
    
    task :test_reminder => :environment do
      puts "----------------------TEST_REMINDER:START-------------------------"
      
      log = ActiveSupport::Logger.new('log/test_reminder.log')
          start_time = Time.now
          log.info "-----------Started at #{start_time}---------------------"
      
       puts "_____START:Send a booking reminder email to everyone with a booking tomorrow."
       puts "_____BEFORE_CHECK:Booking records requiring reminder - count #{Booking.where("booking_date_time BETWEEN ? AND ?", Date.tomorrow.beginning_of_day, Date.tomorrow.end_of_day).where("status = ?", "Confirmed").count}" 
       puts "_____USER: #{Booking.find(2361).email}"
       BookingMailer.booking_reminder_customer(Booking.find(2361)).deliver_now
       log.info "#{Booking.find(2361).email}"
       puts "_____END:Customer booking reminders for tomorrow have been sent"
     
       end_time = Time.now
           duration = (start_time - end_time) / 1.minute
           log.info "Task lasted #{duration} minutes."
           log.info "-----------Finished at #{end_time}---------------------"
           log.info "\n"  
           log.close
      puts "----------------------TEST_REMINDER:END-------------------------"  
     end 
     
     task :get_bookings_by_day => :environment do
       puts "\n----------------------BOOKINGS_REPORT:START-------------------------"
      
        @start_date = Date.new(2016,02,13)
        @end_date = Date.today
        i = @start_date
        
     while i != @end_date do
       puts "#{i} - #{Booking.where("created_at BETWEEN ? AND ?", i.beginning_of_day, i.end_of_day).where("status = ?", "Confirmed").count}"
       i = i+1.day
     end
        
       puts "----------------------BOOKINGS_REPORT:END-------------------------\n"  
      end 

end