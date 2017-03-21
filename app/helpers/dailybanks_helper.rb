module DailybanksHelper
  
  def get_sum_from_array_field(records, field)
    records.inject(0) {|sum, hash| sum + hash[field.to_sym]}
  end
  
  #THIS WAS CREATED TO BYPASS NIL VALUES PROBLEM, occurs when past records have not been completed fully
  def handle_nil_get_sum_from_array_field(records, field)
    records.inject(0) {|sum, hash| sum + hash[field.to_sym].to_i}
  end
  
 
end
