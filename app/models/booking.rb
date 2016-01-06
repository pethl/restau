class Booking < ActiveRecord::Base
  validates :booking_date, presence: true 
  validates :booking_time, presence: true
  validates :number_of_diners, presence: true  
  
  belongs_to :table
  has_one :customer
  accepts_nested_attributes_for :customer
  
  validates :name, :on => :update, presence: true
   validates :phone, :on => :update, presence: true
  
   VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :on => :update, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }
  
  def self.search(search)
    new_search = Date.new search["(1i)"].to_i, search["(2i)"].to_i, search["(3i)"].to_i
    where("booking_date = ?", "#{new_search}") 
  end

  
end
