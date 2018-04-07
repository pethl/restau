class Message
  include ActiveAttr::Model
  
  attribute :name
  attribute :phone
  attribute :email
  attribute :email_confirmation
  attribute :subject
  attribute :message
   
  validates_presence_of :name
  validates_presence_of :email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, format:  { with: VALID_EMAIL_REGEX }, :exclusion =>  { :in => %w(your@email.com), :message => " : Please enter a contact email." }
  validate :check_email_and_confirmation
  validates_presence_of :subject
  validates_presence_of :message
  validates_length_of :message, :maximum => 200#, :minimum => 10

  def check_email_and_confirmation
    errors.add(:email_confirmation, "must match email") if email != email_confirmation
  end
  
  # <tr><td></td><td></td><td> <div class="g-recaptcha" data-sitekey="6LfAB1EUAAAAAHXy9m2d5VhPYihSlJUYef7VS7Sj"></div></td><td></td></tr>


end