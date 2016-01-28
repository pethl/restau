class Customer < ActiveRecord::Base
  
  belongs_to :booking
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX, message: ": Your have an error, please check and re-enter." },
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
  
end
