class Tronc < ActiveRecord::Base
  
  validates :end_date, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  
  validates :foh_split, presence: true
  validates :kitchen_split, presence: true
  validates :card_split, presence: true
  validates :mgr_split, presence: true
  validates :foh_method, presence: true
  validates :kit_method, presence: true
  
  validate :split_must_equal_100
  validates_uniqueness_of :start_date, :scope => [:end_date, :end_date]
  
  TRONC_STATUS_TYPES = ["Current", "Complete"]
  TRONC_METHOD_TYPES = ["By Hours", "Even Split"]
  
  def split_must_equal_100
    unless (self.kitchen_split + self.foh_split + self.card_split + self.mgr_split) ==100
       errors.add(:kitchen_split, ":  Card%, Mgr%, FOH%, Kitchen% must add up to 100 ")
  end
end
end
