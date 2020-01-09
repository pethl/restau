class BookingMailer < ActionMailer::Base
  default from: 'contact@hangfiresouthernkitchen.com'

  def booking_confirmation_customer(booking)
    @booking = booking
    if @booking
      mail(to: @booking.email, subject: "Hang Fire Booking Confirmation for: #{@booking.name} at #{@booking.booking_date_time}")
    end
  end
  
  def booking_confirmation_with_deposit_customer(booking)
    @booking = booking
    if @booking
      mail(to: @booking.email, subject: "Hang Fire Booking Confirmation for: #{@booking.name} at #{@booking.booking_date_time}")
    end
  end
  
  def booking_confirmation_mgmt(booking)
    @booking = booking
    if @booking
      mail(to: 'contact@hangfiresouthernkitchen.com', subject: "New Booking for: #{@booking.name} at #{@booking.booking_date_time}")
    end
  end
  
  def booking_cancellation_customer(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: @booking[:email], subject: "Hang Fire Booking Cancellation for: #{@booking.name} at #{@booking.booking_date_time}")
    end
  end
  
  def booking_cancellation_mgmt(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: 'contact@hangfiresouthernkitchen.com', subject: "HFSK Cancellation: Party of #{@booking.number_of_diners}, for #{@booking.name} at #{@booking.booking_date_time}")
    end
  end
  
  def booking_reminder_customer(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: @booking[:email], subject: "Hang Fire Booking Reminder for: #{@booking.name} at #{@booking.booking_date_time}")
    end
  end
  
  def booking_last_confirmation_customer(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: @booking[:email], subject: "Response Required - Confirm your reservation at Hang Fire Southern Kitchen: #{@booking.name}")
    end
  end
  
  def booking_feedback_request_customer(booking)
    @booking = Booking.find(booking)
     if @booking
      mail(to: @booking[:email], subject: "Hang Fire feedback request for: #{@booking.name}")
    end
  end
  
  def booking_deposit_mgmt(booking)
    @booking = Booking.find(booking.id)
     if @booking
      mail(to: 'contact@hangfiresouthernkitchen.com', subject: "Hang Fire Booking 8+ DEPOSIT REQUIRED for: #{@booking.name} at #{@booking.booking_date_time}")
    end
  end

  def booking_deposit_confirmation_customer(booking)
    @booking = Booking.find(booking.id)
     if @booking
      mail(to: @booking[:email], subject: "Hang Fire Deposit Payment Confirmation")
    end
  end
  
  def booking_deposit_error_customer(booking)
    @booking = Booking.find(booking.id)
     if @booking
      mail(to: @booking[:email], subject: "Hang Fire Deposit Payment Error")
    end
  end
  
  def booking_outstanding_deposit_email_customer(booking)
    @booking = Booking.find(booking.id)
     if @booking
      mail(to: @booking[:email], subject: "Hang Fire Deposit - New Online Payment Option")
    end
  end
    
end