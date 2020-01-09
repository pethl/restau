class FunctionMailer < ApplicationMailer
  default from: 'contact@hangfiresouthernkitchen.com'

  def send_function_enquiry(function)
    @function = function
     if @function
      mail(to: 'contact@hangfiresouthernkitchen.com',  from:"#{@function.email}", subject: "Function Room Enquiry: #{@function.customer_name}, Date: #{@function.event_date}")
    end
  end
end
