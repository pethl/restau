class UserMailer < ApplicationMailer
  default from: 'contact@hangfiresouthernkitchen.com'

  def send_table_stats
    date = Date.today
     
      mail(to: 'pethicklisa@gmail.com', subject: "RESTAU Table Stats: #{date}")
    
  end
end
