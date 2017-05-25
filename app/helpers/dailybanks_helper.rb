module DailybanksHelper
  
  def get_sum_from_array_field(records, field)
    records.inject(0) {|sum, hash| sum + hash[field.to_sym]}
  end
  
 
end
