class Staff < ActiveRecord::Base
  has_many :staffevents, :dependent => :destroy
  accepts_nested_attributes_for :staffevents, :allow_destroy => true
  
  STAFF_STATUS_TYPES = ["Active", "Inactive"]
  STAFF_PAYMENT_TERMS = ["Salaried", "Hourly Rate"]
  STAFF_AREA_TYPES = ["Front of House", "Kitchen"]
   
  validates :name, presence: true
  validates :payment_terms, presence: true
  validates :area, presence: true
  validates_uniqueness_of :name, :scope => [:area, :payment_terms]
 
end
