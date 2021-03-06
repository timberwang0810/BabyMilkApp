class PatientsController < ApplicationController
    before_action :set_patient, only: [:show, :edit, :update, :destroy, :discharge]
    before_action :check_login
    def index
        @active_patients = Patient.alphabetical.paginate(page: params[:page]).per_page(10)
        # @inactive_patients = Patient.inactive.alphabetical.paginate(page: params[:page]).per_page(10)
    end

    def show 
        @all_bottles = Bottle.for_patient(@patient).paginate(page: params[:all_bottles_page]).per_page(5)
        @expired_bottles = Bottle.for_patient(@patient).expired.paginate(page: params[:expired_page]).per_page(5)
        @expiring_bottles_fridge = Bottle.for_patient(@patient).expiring_by_date(DateTime.now.next_day(1)).for_location("Fridge")
        @expiring_bottles_freezer = Bottle.for_patient(@patient).expiring_by_date(DateTime.now.next_day(7)).for_location("Freezer")
    end

    def new
        authorize! :new, @patient
        @patient = Patient.new
    end

    def create
        @patient = Patient.new(patient_params)
        if @patient.save
            # if saved to database
            flash[:notice] = "Successfully created #{@patient.proper_name}."
            redirect_to patient_path(@patient), notice: flash[:notice] # go to show patient page
        else
            # return to the 'new' form
            render action: 'new'
        end
    end

    def edit
        authorize! :update, @patient
    end

    def update
        authorize! :update, @patient
        if @patient.update_attributes(patient_params)
            flash[:notice] = "Updated all information on #{@patient.proper_name}."
            redirect_to @patient
        else
            render action: 'edit'
        end
    end

    def destroy
        authorize! :destroy, @patient
        @patient.bottles.each { |b| b.destroy}
        @patient.visits.each { |v| v.destroy}
        @patient.destroy
        flash[:notice] = "Removed #{@patient.proper_name} from the system."
        redirect_to patients_url, notice: flash[:notice]

    end

    def discharge 
        @visit = @patient.get_current_visit
        @visit.discharge_date = Date.current 
        @visit.save
        @patient.admitted = false 
        @patient.save
        flash[:notice] = "Patient #{@patient.proper_name} discharged."
        redirect_to patient_path(@patient), notice: flash[:notice]
    end 

    private

    def set_patient
        @patient = Patient.find(params[:id])
    end

    def patient_params
        params.require(:patient).permit(:patient_mrn, :first_name, :last_name, :dob, :active)
    end
end
