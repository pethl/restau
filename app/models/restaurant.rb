class Restaurant < ActiveRecord::Base
   has_many :tables
   belongs_to :account
   has_one :rdetail
   
   
   validates :name, presence: true 
   validates :location, presence: true 
   validates :website, presence: true 
   validates :primary_contact, presence: true 
   validates :phone, presence: true 
   validates :email, presence: true 
   
end
