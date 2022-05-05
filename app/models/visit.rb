# Visit model (defines each patient's hospital admission/visit)
class Visit < ApplicationRecord
  belongs_to :patient 

  # Scopes
  scope :by_admission, lambda { order('admission_date DESC') }
  scope :by_discharge, lambda { order('discharge_date DESC') }
  scope :for_patient, -> (patient) { where(patient_id: patient.id) }

  # Validations
  validates_presence_of :patient_id, :account_number, :admission_date
  validates_uniqueness_of :account_number
  validates_date :admission_date, :on_or_before => :discharge_date
  validate :is_admitted, on: :create

  before_save :admit_patient

  # Checks if this visit is still in progress (i.e. the patient has not been discharged yet). 
  #
  # @return [Boolean] whether the visit is still active
  def is_active?
    self.discharge_date == nil
  end

  private 

  # Admits the patient
  def admit_patient
    self.patient.admitted = true unless !self.is_active?
    self.patient.save
  end

  # Checks if the patient is not already admitted upon admission.
  def is_admitted
    if (self.patient.admitted)
      self.errors.add(:base, "Patient #{self.patient.proper_name} has already been admitted!")
    end
  end
end
