class BookingMailer < ActionMailer::Base
  default from: 'contacthangfirebbq@gmail.com'

  def booking_confirmation_successful(booking)
    @booking = booking
    if @booking
      mail(to: 'contacthangfirebbq@gmail.com', subject: "Booking Confirmation for :#{@booking.name} ").deliver
    end
  end
  
  def booking_cancellation(booking)
    @booking = booking
     if @booking
      mail(to: 'contacthangfirebbq@gmail.com', subject: "Booking Cancellation for :#{@booking.name} ").deliver
    end
  end
  
end