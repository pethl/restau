class Dailybank < ActiveRecord::Base
  
  has_many :expenses, :dependent => :destroy
  accepts_nested_attributes_for :expenses, :allow_destroy => true, reject_if: :expenses_attributes_missing
  
  has_many :cashfloats, :dependent => :destroy
  accepts_nested_attributes_for :cashfloats, :allow_destroy => true
  
   DAILYBANK_STATUS_TYPES = ["Balance Morning Float", "Count Evening Till", "Enter Expenses", "Enter Cards", "Enter Till Totals", "Validate and Lock", "Mgmt Review", "Locked", "Mgmt Re-calc"]
   
   def expenses_attributes_missing(attributes)
         # where cannot be missing
         attributes['where'] != nil
       end
   
   validates :effective_date, presence: true
   validates :status, presence: true
   validates :user_id, presence: true 
   validates_uniqueness_of :effective_date, message: '- ! A RECORD FOR THIS DATE ALREADY EXISTS !'  


 HUMANIZED_ATTRIBUTES = {
       :card_payments => "Total Card", :deposit_sold => "Deposits Sold", :deposit_used => "Deposits Used", :till_takings => "Total Sales", :vouchers_sold => "Vouchers Sold", :vouchers_used => "Vouchers Used"  
     }
     
     def self.human_attribute_name(attr, options = {})
        HUMANIZED_ATTRIBUTES[attr.to_sym] || super
      end
      
      
    def self.search(search)
    search_from = search[:from]
    search_to = search[:to]
   if !search_from.blank? && !search_to.blank?
     if search_from < search_to
       where("effective_date BETWEEN ? AND ?", search_from, search_to).sort_by { |hsh| hsh[:effective_date] }
     else
       return a=[]
      end
     else
       return a=[]
      end
    end
  
    def self.search_week(search)
     search_day = search[:day].to_date
    if !search_day.blank? 
        where("effective_date BETWEEN ? AND ?", search_day.beginning_of_week, search_day.end_of_week).sort_by { |hsh| hsh[:effective_date] }
      end
     end
     
     def self.search_month(search)
      search_day = search[:month].to_date
     if !search_day.blank? 
       @dailybanks = Dailybank.where("effective_date BETWEEN ? AND ?", search_day.beginning_of_month, search_day.end_of_month).sort_by { |hsh| hsh[:effective_date] }
     end  
      end 
      
   
end
