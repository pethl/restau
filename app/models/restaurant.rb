class Restaurant < ActiveRecord::Base
   has_many :tables
   belongs_to :account
   has_one :rdetail
   
   
   validates :name, presence: true 
   validates :location, presence: true 
   validates :website, presence: true 
   validates :primary_contact, presence: true 
   validates :phone, presence: true 
   validates :email, presence: true 
   
    default_scope { order('id ASC') }
    
    def self.get_id(name)
      where(name: name).first.id
    end
   
end
