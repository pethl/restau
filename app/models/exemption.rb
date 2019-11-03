class Exemption < ActiveRecord::Base
  
  default_scope { order('exempt_day ASC') }
  
   validates :exempt_day, presence: true  
   validates :exempt_message, presence: true 
   validate :exempt_day_cannot_be_in_the_past
   validate :exempt_day_cannot_be_today
   validate :exempt_must_be_lunch_dinner_or_both

     def exempt_day_cannot_be_in_the_past
       if exempt_day.present? && exempt_day < Date.today
         errors.add(:exempt_day, "can't be in the past")
       end
     end  
     
     def exempt_day_cannot_be_today
       if exempt_day.present? && exempt_day == Date.today
         errors.add(:exempt_day, "can't be the same date as today")
       end
     end  
     
     def exempt_must_be_lunch_dinner_or_both
       if (lunch== false && dinner==false) 
         errors.add(:lunch, "- select if customer should NOT be able to book at lunch service") 
         errors.add(:dinner, "- select if customer should NOT be able to book at dinner service") 
       end
     end
end
