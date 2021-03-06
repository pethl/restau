class Error < ActiveRecord::Base
  
  validates :ref, presence: true 
  validates :msg, presence: true 
  validates :desc, presence: true 
  
   default_scope { order('ref ASC') }
  
  def self.get_msg(ref)
    where(:ref => ref).first.msg
  end
  
end
