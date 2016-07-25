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
     
      puts "_____Send a booking reminder email to everyone with a booking tomorrow+2.day."
      date = Date.tomorrow+1.day
         
      @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where("status = ?", "Confirmed")
      reminders_count = @bookings.count
      puts "_____Booking records requiring reminder - count #{reminders_count}" 
     
      if reminders_count > 0
      @bookings.each.with_index(1) do |booking, index|
              puts "#{index}/#{reminders_count} - #{booking.booking_date_time.to_time} - #{booking.number_of_diners}"
              BookingMailer.booking_reminder_customer(booking).deliver_now
          end
        end
     
      puts "_____Customer booking reminders for tomorrow have been sent"
       puts "----------------------SEND_BOOKING_REMINDER:END-------------------------"
      puts "\n"
    end 
    
    task :test_feedback => :environment do
      puts "----------------------TEST_FEEDBACK:START-------------------------"
      
    date = Date.yesterday
       puts "_____BEFORE_CHECK:Booking records requiring reminder - count #{Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where("status = ?", "Confirmed").count}" 
       puts "_____USER: #{Booking.find(2361).email}"
       BookingMailer.booking_feedback_request_customer(Booking.find(2361)).deliver_now
       puts "_____END:Customer feedback for yesterday have been sent"
       
      puts "----------------------TEST_FEEDBACK:END-------------------------"  
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
      
      task :request_feedback => :environment do
        puts "\n"
         puts "----------------------REQUEST_FEEDBACK:START-------------------------"
     
         puts "_____Send a feedback request email to everyone with a booking yesterday."
         date = Date.yesterday
         
         @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where("status = ?", "Confirmed")
         reminders_count = @bookings.count
         puts "_____Yesterday booking records requiring feedback request - count #{reminders_count}" 
     
         if reminders_count > 0
         @bookings.each.with_index(1) do |booking, index|
                 puts "#{index}/#{reminders_count} - #{booking.booking_date_time.to_time} - #{booking.number_of_diners}"
                 BookingMailer.booking_feedback_request_customer(booking).deliver_now
             end
           end
     
         puts "_____Customer feedback requests for yesterdays bookings have been sent"
         puts "----------------------REQUEST_FEEDBACK:END-------------------------"
         puts "\n"
       end   
       
       task :send_table_stats => :environment do
         puts "\n"
          puts "----------------------SEND_TABLE_STATS:START-------------------------"
     
          puts "_____Send a stats email to system admin weekly."
          customer = Customer.all.count
          confirmed = Booking.where(status: "Confirmed").count
          cancelled = Booking.where(status: "Cancelled").count
          
          puts "#{customer}"
          puts "#{confirmed}"
          puts "#{cancelled}"
          UserMailer.send_table_stats.deliver_now
              
          puts "_____Table stats have been sent"
          puts "----------------------SEND_TABLE_STATS:END-------------------------"
          puts "\n"
        end   
      

end