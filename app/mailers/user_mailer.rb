class UserMailer < ApplicationMailer
  default from: 'contact@hangfiresouthernkitchen.com'

  def send_table_stats
    date = Date.today
     if @message
      mail(to: 'pethicklisa@gmail.com',  from:"#{@message.email}", subject: "RESTAU Table Stats: #{date}")
    end
  end
end
