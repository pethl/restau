class ChargesController < ApplicationController
  def new 
    @booking = Booking.find(params[:id])
  end

  def create
    booking = Booking.find(params[:id])

      token = params[:stripeToken]
        
        begin
              charge = Stripe::Charge.create(
                amount:      (Booking.deposit_amount(booking).second*100).to_i,
                currency:    "gbp",
                source:      token,
                :description => 'Deposit',
                :metadata => {"Booking_ref" => booking.id}
              )
             booking.update_attributes(
                :deposit_pay_method => "Stripe",
                :stripe_deposit_paid_date => DateTime.now,
                :stripe_amount => (Booking.deposit_amount(booking).second*100).to_i,
                :stripe_id => charge.id,
                :deposit_amount => booking.deposit_amount.present? ? (booking.deposit_amount+(Booking.deposit_amount(booking).second).to_i) : (Booking.deposit_amount(booking).second).to_i 
              )
              BookingMailer.booking_deposit_confirmation_customer(booking).deliver_now
              redirect_to hfsk_confirm_deposit_path(id: booking.id)
             
            rescue Stripe::CardError => e
              # The card has been declined or some other error has occurred
              BookingMailer.booking_deposit_error_customer(booking).deliver_now
              redirect_to hfsk_pay_deposit_path(id: booking.id, error: e)
            #render :new
            end    
      end      
end
