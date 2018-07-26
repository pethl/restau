desc "This task is called by the Heroku scheduler add-on"
  
task :purge_held_bookings => :environment do
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
     
     puts "_____Send a booking reminder email to everyone with a booking tomorrow+1.day."
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
     
     puts "_____Customer booking reminders for two days from now have been sent"
      puts "----------------------SEND_BOOKING_REMINDER:END-------------------------"
     puts "\n"
   end 
   
   task :send_booking_reminder_tomorrow => :environment do
     puts "\n"
      puts "----------------------SEND_BOOKING_REMINDER_TOMORROW:START-------------------------"
     
      puts "_____Send a booking reminder email to everyone with a booking tomorrow."
      date = Date.tomorrow
         
      @bookings = Booking.where("booking_date_time BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).where("status = ?", "Confirmed")
      reminders_count = @bookings.count
      puts "_____Booking records requiring reminder - count #{reminders_count}" 
     
      if reminders_count > 0
      @bookings.each.with_index(1) do |booking, index|
              puts "#{index}/#{reminders_count} - #{booking.booking_date_time.to_time} - #{booking.number_of_diners}"
              BookingMailer.booking_reminder_customer(booking).deliver_now
          end
        end
     
      puts "_____Customer booking reminders for two days from now have been sent"
       puts "----------------------SEND_BOOKING_REMINDER_TOMORROW:END-------------------------"
      puts "\n"
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
      cashfloats = Cashfloat.count
      dailybanks = Dailybank.count
      dailystats = Dailystat.count
      expenses = Expense.count
      
      puts "Customer: #{customer}"
      puts "Confirmed: #{confirmed}"
      puts "Cancelled: #{cancelled}"
      puts "Cashfloats: #{cashfloats}"
      puts "Dailybanks: #{dailybanks}"
      puts "Dailystats: #{dailystats}"
      puts "Expenses: #{expenses}"
      puts "Total: #{cancelled+customer+confirmed+cashfloats+dailybanks+dailystats+expenses}"
      UserMailer.send_table_stats.deliver_now
          
      puts "_____Table stats have been sent"
      puts "----------------------SEND_TABLE_STATS:END-------------------------"
      puts "\n"
    end   
    
   task :write_stats_and_purge => :environment do
     puts "\n"
      puts "----------------------DAILY_GENERATE_STATS_DELETE_PAST_BOOKINGS:START-------------------------"
      puts "_____Daily job (part A) to generate simple stats from a given day's bookings."
      @date = get_action_date_for_stats_and_purge
      puts "_____Date: #{@date}"
      
      @day_confirmed = get_confirmed_bookings_by_date(@date)
      @day_cancelled = get_cancelled_bookings_by_date(@date)
      puts "_____Cancelled Bookings: #{@day_cancelled.count}"
      puts "_____Confirmed Bookings: #{@day_confirmed.count}"
      
     if @day_confirmed.count > 0
      puts "_____Diners Fed: #{get_sum_from_array_for_field(@day_confirmed)}"
      puts "_____Avg HeadCount Per Booking: #{number_with_precision(@day_confirmed.average(:number_of_diners), :precision => 2)} diners"
      puts "_____Avg Days Prior to Booking: #{number_with_precision(avg_days_between_booking_made_and_taken(@day_confirmed), :precision => 1)} days"
     end
    write_stats
      puts "_____Daily job (part A) table stats have been generated"
      puts "_____"
      puts "_____Daily job (part B) to delete the records for the action date."
      puts "_____Records to be deleted: #{(@day_confirmed.count)+(@day_cancelled.count)}"
     Booking.where("booking_date_time BETWEEN ? AND ?", @date.beginning_of_day, @date.end_of_day).destroy_all
      puts "_____Daily job (part B) complete -  #{(@day_confirmed.count)+(@day_cancelled.count)} records deleted."
      puts "----------------------DAILY_GENERATE_STATS_DELETE_PAST_BOOKINGS:END-------------------------"
      puts "\n"
   end
   
   task purge_blank_stats: :environment do
     puts "\n"
      puts "----------------------PURGE_BLANK_STATS:START-------------------------"
      puts "Purge blank stats records."
      dailystats_count = Dailystat.all.count
      blank_dailystats_count = Dailystat.where(diners_fed: [nil]).count
      puts "Total stats records - count: #{dailystats_count}" 
      puts "Blank records to be purged - count: #{blank_dailystats_count}" 
     
      Dailystat.where(diners_fed: [nil]).destroy_all
      after_dailystats_count = Dailystat.all.count
      result = dailystats_count-after_dailystats_count
      check_count= result - blank_dailystats_count
      puts "Check count - should be zero: #{check_count}" 
      puts "#{result} blank stats records have been purged"
      puts "----------------------PURGE_BLANK_STATS:END-------------------------"
      puts "\n"
    end
 