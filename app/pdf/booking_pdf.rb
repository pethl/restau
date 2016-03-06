class BookingPdf < Prawn::Document
  
  def initialize(bookings)
    super(top_margin: 70)
    @bookings = bookings
    bookings
  end
    
  def bookings
    text "Date \##{@bookings.first.booking_date_time.to_date}", size: 16, style: :bold
    move_down 20
    @bookings.first.map do |booking| 
      
      text [booking.name, booking.phone, booking.email, booking.booking_date_time, booking.number_of_diners, booking.child_friendly, booking.source]
    end 
  end

    def line_item_rows
      [["Customer", "Phone", "Email", "Booking Time", "Diners", "Child Seat?", "Source"]] +
    
      @bookings.first.map do |booking| 
        
        text [booking.name, booking.phone, booking.email, booking.booking_date_time, booking.number_of_diners, booking.child_friendly, booking.source]
    end
  end
      
end