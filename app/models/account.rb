class Account < ActiveRecord::Base
  has_many :restaurants
  
  validates :company_name, presence: true 
  validates :primary_contact, presence: true 
  validates :phone, presence: true 
  validates :email, presence: true 
 
end
