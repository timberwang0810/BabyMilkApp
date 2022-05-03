class ScanpatientController < ApplicationController
  before_action :check_login

  def scan
    authorize! :edit, Patient
  end
  def find
    authorize! :update, Patient
    patient_account_num = params[:other][:patient_account_num]
    visit = Visit.where(account_number: patient_account_num).first
    if visit != nil && visit.is_active?
        redirect_to patient_path(visit.patient)
    else 
        flash[:notice] = "Patient doesn't exist, or the patient has already been discharged!"
        render action: 'scan', notice: flash[:notice]
    end
  end
end
