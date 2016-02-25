class Cashfloat < ActiveRecord::Base
  
  validates :float_type, presence: true 
  validates :period, presence: true 
  validates :completed_by, presence: true 
  validates :user_code, presence: true 
  
  FLOAT_TYPES = ["Safe", "Main Till", "Downstairs Bar Till"]
   PERIOD_TYPES = ["Morning", "Evening"]
  
   
   def self.float_target(float_type)
     
     #GET THE FLOAT_TARGET VALUE FROM SYSTEM PARAMS
      if float_type == "Safe" 
         target = Rdetail.get_value(1, "safe_float")
        return target
      elsif float_type == "Main Till" 
        target = Rdetail.get_value(1, "till_float_main")
        return target
      else
          target = Rdetail.get_value(1, "till_float_bar")
         return target
      end
      
   end
   
   def self.count_cash(cashfloat)
     @cashfloat = cashfloat
       
      #UPDATE THE TOTAL AND GAP FIELDS
      total = (@cashfloat.fifties*50)+(@cashfloat.twenties*20)+(@cashfloat.tens*10)+(@cashfloat.fives*5)+
      (@cashfloat.two_pound_bag*20)+ (@cashfloat.two_pound_single*2)+
      (@cashfloat.pound_bag*20)+ (@cashfloat.pound_single*1)+
      (@cashfloat.fifty_bag*10)+ (@cashfloat.fifty_single*0.5)+
      (@cashfloat.twenty_bag*10)+ (@cashfloat.twenty_single*0.2)+
      (@cashfloat.ten_bag*5)+ (@cashfloat.ten_single*0.1)+
      (@cashfloat.five_bag*5)+ (@cashfloat.five_single*0.05)+
      (@cashfloat.two_bag)+ (@cashfloat.two_single*0.02)+
      (@cashfloat.one_bag)+ (@cashfloat.one_single*0.01)
      
       @cashfloat.float_actual = total
       @cashfloat.float_gap =  @cashfloat.float_target -  @cashfloat.float_actual
       @cashfloat.save
       return @cashfloat
       end
  
end
