class Product < ActiveRecord::Base
    validates :name, presence: true 
    validates :price, presence: true 
    validates :weight, presence: true 
    validates :status, presence: true
    validates :category_id, presence: true 
    validates :sort, presence: true  
    
    default_scope { order('sort ASC') } 
 
    belongs_to :category
  
  STATUS_TYPES = ["Live", "Suspended"]
  
  
  def self.import(file)
      	 CSV.foreach(file.path, headers: true) do |row|
         		 Product.create! row.to_hash
      	end
    	end
  
end
