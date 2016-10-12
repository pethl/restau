class Customer < ActiveRecord::Base
  
  belongs_to :booking
  
  default_scope { order('name ASC') }
  
  
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
      where("name LIKE ?", "%#{name}%") 
       
      elsif !email.blank?
          where("email LIKE ?", "%#{email}%")  
      else 
          where("phone LIKE ?", "%#{phone}%") 
        end
   end
   
   def self.write_contact(booking)
     @booking = booking
        @customer = Customer.new(name: @booking.name, email: @booking.email, phone: @booking.phone)
        
          if @customer.save
           else
             end
        end

  
end
