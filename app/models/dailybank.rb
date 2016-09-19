class Dailybank < ActiveRecord::Base
  
   DAILYBANK_STATUS_TYPES = ["Created", "Draft", "Locked"]
   
   validates :effective_date, presence: true
   validates :status, presence: true
   validates_numericality_of :banking, :greater_than_or_equal_to => 0, message: 'cannot be blank'
   validates_numericality_of :card_payments, :greater_than_or_equal_to => 0, message: 'cannot be blank'
   validates_numericality_of :expenses, :greater_than_or_equal_to => 0, message: 'cannot be blank'
   validates_numericality_of :till_takings, :greater_than_or_equal_to => 0, message: 'cannot be blank'
   validates_numericality_of :vouchers_sold, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none sold'
   validates_numericality_of :vouchers_used, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
   validates_numericality_of :deposit_sold, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none sold'
   validates_numericality_of :deposit_used, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero if none used'
   validates_numericality_of :user_variance, :greater_than_or_equal_to => 0, message: 'cannot be blank, enter zero none'
 
   # :wet_takings, :dry_takings, :merch_takings
   
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
