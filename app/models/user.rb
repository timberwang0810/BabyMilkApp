# User model 
class User < ApplicationRecord
    has_secure_password
    
    validates_presence_of :first_name, :last_name 
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates_presence_of :password, :on => :create 
    validates_presence_of :password_confirmation, :on => :create 
    validates_confirmation_of :password, message: "does not match"
    validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long", :allow_blank => true
    validates_inclusion_of :role, in: %w( admin nurse ), message: "is not recognized in the system"

    scope :alphabetical, -> { order('last_name, first_name') }

    before_destroy :cannot_destroy_object

    # Gets the user's name in the form "Last, First"
    #
    # @return [String] the user's name
    def name
        "#{last_name}, #{first_name}"
    end
    
    # Gets the user's name in the form "First Last"
    #
    # @return [String] the user's proper name
    def proper_name
        "#{first_name} #{last_name}"
    end

    
    ROLES = [['Admin', :admin],['Nurse', :nurse]]
    NURSEROLE = [['Nurse', :nurse]]

    # Checks if the user's role is a valid role in the system
    #
    # @param authorized_role [String] input role
    # @return [Boolean] the role's validity
    def role?(authorized_role)
        return false if role.nil?
        role.downcase.to_sym == authorized_role
    end

    # Try authenticate by username and password
    # @param username [String] user username
    # @param password [String] user password
    def self.authenticate(username, password)
        find_by_username(username).try(:authenticate, password)
    end

    # Generates a password reset token
    def generate_password_token!
        self.reset_password_token = generate_token
        self.reset_password_sent_at = Time.now.utc
        save!
    end
       
    # Checks if the password reset token has expired
    # @return [Boolean] validity of the password reset token
    def password_token_valid?
        (self.reset_password_sent_at + 4.hours) > Time.now.utc
    end
       
    # Resets the password
    # @param password [String] new password
    def reset_password!(password)
        self.reset_password_token = nil
        self.password = password
        save!
    end
       
    private
       
    # Generates a hashed string as token
    def generate_token
        SecureRandom.hex(10)
    end
end
