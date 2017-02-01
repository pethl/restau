class Expense < ActiveRecord::Base
  
  belongs_to :dailybank
  
   validates :dailybank_id, presence: true
   validates :what, presence: true
   validates :where, presence: true
   validates :price, presence: true
   validates :ref, presence: true
   
end
