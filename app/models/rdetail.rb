class Rdetail < ActiveRecord::Base
  
  belongs_to :restaurant
  validates :restaurant_id, presence: true 
  validates :big_table_count, presence: true 
  validates :large_table_count, presence: true 
  validates :max_current_diners, presence: true   
  validates :max_diners_at_current_time, presence: true 
  validates :current_diners_window_start, presence: true 
  validates :current_diners_window_end, presence: true 
 
 default_scope { order('id ASC') }
 
 def self.get_value(restaurant_id,field_name)
   field_name = field_name.to_sym
   answer = where(:restaurant_id => restaurant_id).first
   return answer[field_name]
 end
  
 
end
