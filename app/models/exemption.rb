class Exemption < ActiveRecord::Base
   validates :exempt_day, presence: true  
    validates :exempt_message, presence: true  
end
