class Dailybank < ActiveRecord::Base
  
  has_many :expenses, :dependent => :destroy
  accepts_nested_attributes_for :expenses, :allow_destroy => true, reject_if: :expenses_attributes_missing
  
  has_many :cashfloats, :dependent => :destroy
  accepts_nested_attributes_for :cashfloats, :allow_destroy => true
  
   DAILYBANK_STATUS_TYPES = ["Balance Morning Float", "Count Evening Till", "Enter Expenses", "Enter Cards", "Enter Till Totals", "Validate and Lock", "Mgmt Review", "Locked"]
   
   def expenses_attributes_missing(attributes)
         # where cannot be missing
         attributes['where'] != nil
       end
   
   validates :effective_date, presence: true
   validates :status, presence: true
   validates :user_id, presence: true 
   validates_uniqueness_of :effective_date, message: '- ! A RECORD FOR THIS DATE ALREADY EXISTS !'  
#   validates_presence_of :till_float, :greater_than_or_equal_to => 0, message: 'cannot be blank'
#   validates_presence_of :till_cash, :greater_than_or_equal_to => 0, message: 'cannot be blank'
#   validates_presence_of :card_payments, :greater_than_or_equal_to => 0, message: 'cannot be blank'
#   validates_presence_of :expenses, :greater_than_or_equal_to => 0, message: 'cannot be blank'
#   validates_presence_of :wet_takings, :greater_than_or_equal_to => 0, message: 'cannot be blank'
#   validates_presence_of :dry_takings, :greater_than_or_equal_to => 0, message: 'cannot be blank'
#   validates_presence_of :merch_takings, :greater_than_or_equal_to => 0, message: 'cannot be blank'
   
#   validates_presence_of :till_takings, :greater_than_or_equal_to => 0, message: 'cannot be blank'
 #  validates_presence_of :vouchers_sold, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none sold'
#   validates_presence_of :vouchers_used, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
#   validates_presence_of :deposit_sold, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none sold'
#   validates_presence_of :deposit_used, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
 #  validates_presence_of :user_variance, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter variance value which may be zero'

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
