class Accruel_rate < ActiveRecord::Base
  validates_uniqueness_of :effective_date, :scope => [:rate]
  validates :effective_date, presence: true
  validates :rate, presence: true
  
end
