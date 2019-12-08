class Staffhour < ActiveRecord::Base
  belongs_to :staff
  belongs_to :accruel_rate
  before_save :set_wk_accrued_hours
  
  validates :staff_id, presence: true
  validates :week_end_date, presence: true
  validates :accruel_rate_id, presence: true
  validates_uniqueness_of :week_end_date, :scope => [:staff_id, :accruel_rate_id]
  
  def set_wk_accrued_hours
     self.wk_accrued_hours = self.hours*Accruel_rate.last.rate
  end
  
end
