class Bottle < ApplicationRecord
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods
  
  belongs_to :patient
  #belongs_to :checkin_nurse_id
  #belongs_to :checkout_nurse_id

  validates_presence_of :collected_date, :storage_location
  #validates_datetime :administration_date, on_or_after: :collected_date
  #add validations for different types of expiration dates
  #validates_datetime :expiration_date, after: :collected_date 

  validates :storage_location, inclusion: { in: %w(fridge freezer), 
    message: "%{value} is not a valid storage location" }


  scope :by_patient, -> { joins(:patient).order('patients.last_name, patients.first_name')}
  scope :for_patient, ->(patient) { where(patient_id: patient.id) }

  scope :by_collection, -> { order('collected_date')}
  scope :by_administration, -> { order('administration_date')}
  scope :by_expiration, -> { order('expiration_date')}

  #callbacks
  #before_save
  before_save :set_bottle_details
  after_destroy :make_bottle_inactive

  #fix this
  protected
  def set_bottle_details
    if self.storage_location == 'fridge'
      self.expiration_date = self.collected_date + 14
    elsif self.storage_location =='freezer'
      self.expiration_date = self.collected_date + 182.5
    else
      self.errors.add(:bottle, "invalid storage location")
    end
  end

  def make_bottle_inactive
    self.administration_date = Date.today
    self.make_inactive
  end




end
