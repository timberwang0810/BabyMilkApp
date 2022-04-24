class Verification
    include ActiveModel::Model

    attr_accessor :bottle_id, :patient_id

    validates :patient_id, presence: true
    validates :bottle_id, presence: true

    def verify
        @patient = Patient.find(patient_id)
        @bottle = Bottle.find(bottle_id)
        if @patient.id == @bottle.patient.id
            return true
        else
            return false
        end
    end

    def expired
        @bottle = Bottle.find(bottle_id)
        if @bottle.expiration_date < Date.today
            return true
        else
            return false
        end
    end
end