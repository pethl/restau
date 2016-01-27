class BookingMailer < ActionMailer::Base
  default from: 'contacthangfirebbq@gmail.com'

  def booking_confirmation(booking)
    @booking = booking
    if @booking
      mail(to: @booking.email, subject: "Booking Confirmation for: #{@booking.name} ")
      mail(to: 'contacthangfirebbq@gmail.com', subject: "Booking Confirmation for: #{@booking.name} ")
    end
  end
  
  def booking_cancellation(booking)
    @booking = booking
     if @booking
      mail(to: @booking.email, subject: "Booking Cancellation for: #{@booking.name} ")
    end
  end
  
end