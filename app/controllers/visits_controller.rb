class VisitsController < ApplicationController
    before_action :set_visit, only: [:edit, :update, :destroy]
    before_action :check_login

    def new
        @visit = Visit.new
        puts params
        @visit.patient = Patient.find(params[:patient_id])
        @visit.admission_date = Date.current
    end

    def create
        @visit = Visit.new(visit_params)
        if @visit.save
          flash[:notice] = "Successfully admitted #{@visit.patient.proper_name}."
          redirect_to patient_path(@visit.patient), notice: flash[:notice]
        else
          render action: 'new'
        end
    end

    def destroy
        authorize! :destroy, @visit
        @visit.destroy
        redirect_to patients_url
    end

    private
    def set_visit
        @visit = Visit.find(params[:id])
    end
    def visit_params
        params.require(:visit).permit(:patient_id, :account_number, :admission_date)
    end
end
