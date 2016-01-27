class Message
  include ActiveAttr::Model
  
  attribute :name
  attribute :phone
  attribute :email
  attribute :subject
  attribute :message
   
  validates_presence_of :name
  validates_presence_of :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }
  validates_presence_of :subject
  validates_presence_of :message
  validates_length_of :message, :maximum => 500

end