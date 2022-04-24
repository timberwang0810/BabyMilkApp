class User < ApplicationRecord
    has_secure_password
    
    #has_many :bottles

    validates_presence_of :first_name, :last_name 
    validates :username, presence: true, uniqueness: { case_sensitive: false }
    validates_presence_of :password, :on => :create 
    validates_presence_of :password_confirmation, :on => :create 
    validates_confirmation_of :password, message: "does not match"
    validates_length_of :password, :minimum => 4, message: "must be at least 4 characters long", :allow_blank => true
    #what are the different users, do we specify admin here or no 
    validates_inclusion_of :role, in: %w( admin nurse ), message: "is not recognized in the system"

    scope :alphabetical, -> { order('last_name, first_name') }

    before_destroy :cannot_destroy_object

    def name
        "#{last_name}, #{first_name}"
    end
    
    def proper_name
        "#{first_name} #{last_name}"
    end

    
    ROLES = [['Admin', :admin],['Nurse', :nurse]]

    def role?(authorized_role)
        return false if role.nil?
        role.downcase.to_sym == authorized_role
    end

    # login by username
    def self.authenticate(username, password)
        find_by_username(username).try(:authenticate, password)
    end


end
