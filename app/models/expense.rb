class Expense < ActiveRecord::Base
  belongs_to :dailybank
  before_save :populate_ref
  before_save :titleize_where
   
   validates_uniqueness_of :ref
   validates :dailybank_id, presence: true
   validates :what, presence: true
   validates :where, presence: true
   validates :price, presence: true
   validates :ref, presence: true
   
#THESE DO NOT VALIDATE NO USER MESSAGE IF ERRORS 
 
   private

   def titleize_where
     self.where = self.where.titleize
   end
   
     def populate_ref
       Rails.logger.debug("in pop_ref: #{self.inspect}")
       if new_record?
         while !valid? || self.ref.nil?
           if Expense.all.count == 0
             self.ref = 3001
            else
             self.ref = Expense.all.last.ref+1
          end
           #SecureRandom.random_number(1_000_000_000).to_s(36)
         end
       end
     end
   
end
