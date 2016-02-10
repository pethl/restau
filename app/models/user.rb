class User < ActiveRecord::Base
  has_secure_password 
  before_save { email.downcase! }
  before_save :create_remember_token
   
  validates :name, presence: true, length: { maximum: 40 },
                      uniqueness: true
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  
  
  private

      def create_remember_token
        self.remember_token = SecureRandom.urlsafe_base64
      end
                    
end
