class Restaurant < ActiveRecord::Base
  
   belongs_to :account
   has_many :tables
   
end
