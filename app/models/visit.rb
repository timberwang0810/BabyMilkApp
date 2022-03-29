class Visit < ApplicationRecord
  include AppHelpers::Deletions
  
  belongs_to :patient 

  # Scopes
  # by_admission -- orders results chronologically by admission date
  # by_discharge -- orders results chronologically by discharge date
  scope :by_admission, lambda { order('admission_date DESC') }
  scope :by_discharge, lambda { order('discharge_date DESC') }

  # Validations
  validates_presence_of :patient_id,:account_number, :admission_date
  validates_uniqueness_of :account_number
  validates_date :admission_date, :on_or_before :discharge_date

  before_destroy :cannot_destroy_object


end
