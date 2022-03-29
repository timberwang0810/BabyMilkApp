require 'test_helper'

class VisitTest < ActiveSupport::TestCase
  should belong_to(:patient)
  
  
  # Validation macros...
  should validate_presence_of(:patient_id)
  
  # Validating presence...
  should validate_presence_of(:account_number)
  should validate_presence_of(:admission_date)
  should validate_uniqueness_of(:account_number)

  # Validating date...
  should_not allow_value("bad").for(:admission_date)
  should_not allow_value(2).for(:admission_date)
  should_not allow_value(3.14159).for(:admission_date) 
  should_not allow_value(nil).for(:admission_date) 
  

end
