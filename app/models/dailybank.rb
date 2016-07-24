class Dailybank < ActiveRecord::Base
  
   BANK_STATUS_TYPES = ["Draft", "Locked"]
   
   validates_numericality_of :till_cash, :greater_than_or_equal_to => 0
   validates_numericality_of :till_float, :greater_than_or_equal_to => 0
   validates_numericality_of :card_payments, :greater_than_or_equal_to => 0
   validates_numericality_of :expenses, :greater_than_or_equal_to => 0
   validates_numericality_of :till_takings, :greater_than_or_equal_to => 0
   validates_numericality_of :vouchers_sold, :greater_than_or_equal_to => 0
   validates_numericality_of :vouchers_used, :greater_than_or_equal_to => 0
   validates_numericality_of :deposit_sold, :greater_than_or_equal_to => 0
   validates_numericality_of :deposit_used, :greater_than_or_equal_to => 0
   validates_numericality_of :user_variance, :greater_than_or_equal_to => 0
 
   # :wet_takings, :dry_takings, :merch_takings
   
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
