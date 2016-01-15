class Booking < ActiveRecord::Base
  belongs_to :table
  
  validates :booking_date, presence: true 
  validates :booking_time, presence: true
  validates :number_of_diners, presence: true  
#  validates :name, :on => :update, presence: true
#  validates :phone, :on => :update, presence: true
  
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#  validates :email, :on => :update, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }
  
  def self.search(search)
#    new_search = Date.new search["(1i)"].to_i, search["(2i)"].to_i, search["(3i)"].to_i
#     no longer using date-select so dont need this extra formatting

# => get Confirmed bookings only
     where("booking_date = ? AND status = ?", "#{search}", "Confirmed") 
  end

  
end
