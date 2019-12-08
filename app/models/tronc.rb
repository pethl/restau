class Tronc < ActiveRecord::Base
  
  validates :end_date, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  
  validates :foh_split, presence: true
  validates :kitchen_split, presence: true
  validate :split_must_equal_100
  validates_uniqueness_of :start_date, :scope => [:end_date, :end_date]
  
  
  
  TRONC_STATUS_TYPES = ["Current", "Complete"]
  
  def split_must_equal_100
    unless (self.kitchen_split + self.foh_split) ==100
       errors.add(:kitchen_split, ":  FOH% and Kitchen% must add up to 100 ")
  end
end
end
