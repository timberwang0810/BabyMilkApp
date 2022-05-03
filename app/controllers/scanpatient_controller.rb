class ScanpatientController < ApplicationController
  before_action :check_login

  def scan

  end
  def find
    patient_account_num = params[:other][:patient_account_num]
    visit = Visit.where(account_number: patient_account_num).first
    if visit != nil && visit.is_active?
        redirect_to patient_path(visit.patient)
    else 
        flash[:error] = "Patient doesn't exist, or the patient has already been discharged!"
        render action: 'scan', error: flash[:error]
    end
  end
end
