class Cashfloat < ActiveRecord::Base
  belongs_to :dailybank
  
  validates :float_type, presence: true 
  validates :period, presence: true 
  validates :completed_by, presence: true 
 # validates :user_code, presence: true ]
  validates_presence_of :fifties, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :twenties, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :tens, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :fives, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :two_pound_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :pound_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :fifty_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validates_presence_of :twenty_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used' 
  validates_presence_of :ten_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used' 
  validates_presence_of :five_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used' 
  validates_presence_of :two_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used' 
  validates_presence_of :one_single, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
  validate :must_be_divisible_by_itself
  validate :must_balance_target_float
 # validate :generate_cheat_value
  
  HUMANIZED_ATTRIBUTES = {
      :two_pound_single => "two pound coins", :pound_single => "pound coins", :fifty_single => "fifty pence coins", :twenty_single => "twenty pence coins", :ten_single => "ten pence coins", :five_single => "five pence coins", :two_single => "two pence coins", :one_single => "one pence coins"  
    }
  
    def self.human_attribute_name(attr, options = {})
       HUMANIZED_ATTRIBUTES[attr.to_sym] || super
     end
  
  FLOAT_TYPES = ["Safe", "Main Till", "Downstairs Bar Till"]
  PERIOD_TYPES = ["Morning", "Evening"]
  
  def must_be_divisible_by_itself
     if completed!="Completed"
    if ((fifties.present?) && (fifties > 0)  && ((fifties % 50 != 0)))
          errors.add(:fifties, "not a multiple of 50")
        end
     if ((twenties.present?) && (twenties > 0)  && ((twenties % 20 != 0)))
          errors.add(:twenties, "not a multiple of 20")
        end
    if ((tens.present?) && (tens > 0)  && ((tens % 10 != 0)))
          errors.add(:tens, "not a multiple of 10")
        end   
    if ((fives.present?) && (fives > 0)  && ((fives % 5 != 0)))
          errors.add(:fives, "not a multiple of 5")
        end 
    if ((two_pound_single.present?) && (two_pound_single > 0)  && ((two_pound_single % 2 != 0)))
          errors.add(:two_pound_single, "not a multiple of 2")
        end 
    if ((fifty_single.present?) && (fifty_single > 0)  && ((fifty_single % 0.5 != 0)))
          errors.add(:fifty_single, "not a multiple of 50p")
        end 
    if ((twenty_single.present?) && (twenty_single > 0)  && ((twenty_single % 0.2 != 0)))
          errors.add(:twenty_single, "not a multiple of 20p")
        end 
    if ((ten_single.present?) && (ten_single > 0)  && ((ten_single % 0.1 != 0)))
          errors.add(:ten_single, "not a multiple of 10p")
        end 
    if ((five_single.present?) && (five_single > 0)  && ((five_single % 0.05 != 0)))
              errors.add(:five_single, "not a multiple of 5p")
            end 
    if ((two_single.present?) && (two_single > 0)  && ((two_single % 0.02 != 0)))
          errors.add(:two_single, "not a multiple of 2p")
        end 
    if ((one_single.present?) && (one_single > 0)  && ((one_single % 0.01 != 0)))
          errors.add(:one_single, "not a multiple of 1p")
    end 
        end 
  end
  
  def must_balance_target_float
    #do not run if user has clicked float override - this is what they are overriding
    unless ((override == true) && (float_comment.present?))
    # do not run when user is closing float and marking as complete
    if period== "Morning" && completed!="Completed"
      #do not run if any values missing, allow the above validations to take care of this first
      if ((fifties.present?) && (twenties.present?) && (tens.present?) && (fives.present?) && (two_pound_single.present?) && (pound_single.present?) && (fifty_single.present?) && (twenty_single.present?) && (ten_single.present?) && (five_single.present?) && (two_single.present?) && (one_single.present?))
        total = (fifties+twenties+tens+fives+two_pound_single+pound_single+fifty_single+twenty_single+ten_single+five_single+two_single+one_single)
        gap = float_target - total
        if float_target - total != 0
          errors.add(:float_target, "not balanced, gap of £#{gap}, recount or use override with comment to continue.")
        end
      end
    end
    end
  end
  
#  def generate_cheat_value
#    if period== "Evening"
#      cheat_total = #(fives+two_pound_single+pound_single+fifty_single+twenty_single+ten_single+five_single+two_single+one_single)
 #     errors.add(:float_target, "cheat value is £#{cheat_total}")
  #  end
#  end
   
   
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
      big_notes =(@cashfloat.fifties)+(@cashfloat.twenties)+(@cashfloat.tens)
      total = (@cashfloat.fifties)+(@cashfloat.twenties)+(@cashfloat.tens)+(@cashfloat.fives)+
      (@cashfloat.two_pound_single)+(@cashfloat.pound_single)+
      (@cashfloat.fifty_single)+(@cashfloat.twenty_single)+
      (@cashfloat.ten_single)+(@cashfloat.five_single)+
      (@cashfloat.two_single)+(@cashfloat.one_single)
      
       @cashfloat.float_actual = total
       @cashfloat.float_gap =  @cashfloat.float_target -  @cashfloat.float_actual
       @cashfloat.cheat = total-big_notes
       @cashfloat.save
       return @cashfloat
       end
  
end
