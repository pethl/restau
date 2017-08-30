class Function < ActiveRecord::Base
  
  validates :event_date, presence: true
  validates :customer_name, presence: true
  validates :phone, presence: true  
  validates :email, presence: true 
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }
 
  TANDC_TYPES = ["NO", "YES"]
  MENU_TYPES = ["NO", "YES"]
  STATUS_TYPES = ["Customer Enquiry", "Enquiry in discussion", "Confirmed"]
  EVENT_TYPES = ["Social Party", "Business Event", "Formal Dinner", "Cocktail Party", "Drinks Reception"]
  
   default_scope { order('event_date ASC') }
end
