class BookingMailer < ActionMailer::Base
  default from: 'contacthangfirebbq@gmail.com'

  def booking_confirmation_successful(booking)
    @booking = booking
    #@sale = Sale.find_by(stripe_id: @charge.id)
    if @booking
      mail(to: 'contacthangfirebbq@gmail.com', subject: "Booking Confirmation for :#{@booking.name} ").deliver
    end
  end
end