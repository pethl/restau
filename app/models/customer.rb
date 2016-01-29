class Customer < ActiveRecord::Base
  
  belongs_to :booking
  
  #customer is mainly for subscription management and easy seach with link to booking via email.
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX, message: ": You have an error, please check and re-enter." },
                    uniqueness: { case_sensitive: false }


  def self.search(search)
   name = search[:name]
   email = search[:email]
   phone = search[:phone]
   
   if !name.blank?
      Rails.logger.debug("in name: #{name}")
      where("name LIKE ?", "%#{name}%") 
       
      elsif !email.blank?
          Rails.logger.debug("in email: #{email}")
          where("email LIKE ?", "%#{email}%")  
      else 
          Rails.logger.debug("in phone: #{phone}")
          where("phone LIKE ?", "%#{phone}%") 
        end
   end
   
   def self.write_contact(booking)
     @booking = booking
        @customer = Customer.new(name: @booking.name, email: @booking.email, phone: @booking.phone)
        
          if @customer.save
            Rails.logger.debug("000000000000_CUSTOMER_SAVE_RECORD : #{@customer.inspect}")  
          else
            Rails.logger.debug("000000000000_CUSTOMER_DID NOT SAVE_RECORD : #{@customer.inspect}")  
          end
        end

  
end
