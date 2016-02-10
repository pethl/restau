class BookingMailer < ActionMailer::Base
  default from: 'contacthangfirebbq@gmail.com'

  def booking_confirmation_customer(booking)
    @booking = booking
    if @booking
      mail(to: @booking.email, subject: "Booking Confirmation for: #{@booking.name} ")
    end
  end
  
  def booking_confirmation_mgmt(booking)
    @booking = booking
    if @booking
      mail(to: 'bookings@hangfiresouthernkitchen.com', subject: "New Booking for: #{@booking.name} ")
    end
  end
  
  def booking_cancellation_customer(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: @booking[:email], subject: "Booking Cancellation for: #{@booking.name} ")
    end
  end
  
  def booking_cancellation_mgmt(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: 'bookings@hangfiresouthernkitchen.com', subject: "Booking Cancellation for: #{@booking.name} ")
    end
  end
  
end