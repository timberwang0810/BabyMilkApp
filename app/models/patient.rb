class Patient < ApplicationRecord
    #include AppHelpers::Activeable::InstanceMethods
    #extend AppHelpers::Activeable::ClassMethods

    # Relationships
    has_many :visits
    has_many :bottles 

    # Scopes
    scope :alphabetical, -> { order('last_name, first_name') }
    
    # Validations
    validates_presence_of :patient_mrn, :first_name, :last_name, :dob, :active
    validates_uniqueness_of :patient_mrn
    validates_date :dob, :on_or_before => lambda { Date.current }

    # Methods
    def name
        "#{last_name}, #{first_name}"
    end
    
    def proper_name
        "#{first_name} #{last_name}"
    end

    def get_age
        (((Date.today-self.dob).to_i)/365.25).to_i
    end


end
