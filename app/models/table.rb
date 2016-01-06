class Table < ActiveRecord::Base
  
   belongs_to :resturant
   has_many :bookings
end
