class Staffevent < ActiveRecord::Base
  belongs_to :staff
  
  validates :event_date, presence: true
  validates :event_reason, presence: true
  
   STAFFEVENT_REASONS = ["Rate Change", "Promotion", "Maternity Leave", "Resigned", "New Joiner", "Re-joined"]
end
