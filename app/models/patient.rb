require "openssl"

# Patient model
class Patient < ApplicationRecord
    @@cipher_key = ENV["CIPHER_KEY"]
    # Relationships
    has_many :visits
    has_many :bottles 

    # Scopes
    scope :alphabetical, -> { order('last_name, first_name') }
    
    # Validations
    validates_presence_of :patient_mrn, :first_name, :last_name, :dob
    validates_uniqueness_of :patient_mrn
    validates_date :dob, :on_or_before => lambda { Date.current }

    before_create :encode_mrn 
    # Methods

    # Gets the patient's name in the form "Last, First"
    #
    # @return [String] the patient's name
    def name
        "#{last_name}, #{first_name}"
    end
    
    # Gets the patient's name in the form "First Last"
    #
    # @return [String] the patient's proper name
    def proper_name
        "#{first_name} #{last_name}"
    end

    # Gets the patient's age from his/her date of birth
    #
    # @return [Int] the patient's age
    def get_age
        (((Date.today-self.dob).to_i)/365.25).to_i
    end

    # Gets the patient's MRN (the MRN is encrypted in the database)
    #
    # @return [String] the patient's MRN
    def get_mrn
        decrypt(@@cipher_key, self.patient_mrn)
    end

    # Gets the patient's current visit (or nil if patient is currently unadmitted)
    #
    # @return [Visit] the patient's current visit, if any
    def get_current_visit
        if !self.admitted?
            return nil 
        end
        self.visits.select{|v| v.is_active?}.first
    end
    class << self
        # Gets an encrypted string from a patient's MRN
        # @param mrn [String] unencrypted MRN string
        # @return [String] encrypted MRN string
        def get_encrypted_mrn(mrn)
            encrypt(@@cipher_key, mrn)
        end
        private 

        # Decryption algorithm
        def encrypt(key, str)
            cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
            cipher.key = key
            s = cipher.update(str) + cipher.final
            s.unpack('H*')[0].upcase
        end
    end

    private

    # Encryption Algorithm
    def encrypt(key, str)
            cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').encrypt
            cipher.key = key
            s = cipher.update(str) + cipher.final
            s.unpack('H*')[0].upcase
    end

    # Decryption Algorithm
    def decrypt(key, str)
        cipher = OpenSSL::Cipher.new('DES-EDE3-CBC').decrypt
        cipher.key = key
        cipher.padding = 0
        s = [str].pack("H*").unpack("C*").pack("c*")
        cipher.update(s) + cipher.final
    end

    # Encrypt the newly created patient's MRN.
    def encode_mrn
        self.patient_mrn = encrypt(@@cipher_key, self.patient_mrn)
    end
end
