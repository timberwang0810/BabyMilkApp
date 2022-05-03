# Object used for verification
class Verification
    include ActiveModel::Model

    attr_accessor :bottle_id, :patient_id

    validates :patient_id, presence: true
    validates :bottle_id, presence: true

    # Verifies that the scanned bottle belongs to the scanned patient
    # @return [Boolean] verification result
    def verify
        @bottle = Bottle.find(Bottle.get_bottle_id(bottle_id))
        @patient = Visit.where(account_number: patient_id).first.patient
        if @patient.id == @bottle.patient.id
            return true
        else
            return false
        end
    end

    # Checks if the scanned bottle has expired
    # @return [Boolean] expiration status of bottle
    def expired
        @bottle = Bottle.find(Bottle.get_bottle_id(bottle_id))
        if @bottle.expiration_date < DateTime.now
            return true
        else
            return false
        end
    end
end