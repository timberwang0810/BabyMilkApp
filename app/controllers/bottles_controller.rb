class BottlesController < ApplicationController
    before_action :set_bottle, only: [:show, :edit, :update, :delete, :destroy, :reprint]
    before_action :check_login
    def index
        @active_bottles = Bottle.by_patient.paginate(page: params[:page]).per_page(10)
    end

    def new
        authorize! :new, @bottle
        @bottle = Bottle.new
        puts params
        @bottle.patient = Patient.find(params[:patient_id])
    end

    def create
        authorize! :create, @bottle
        puts params[:other][:amount]
        amount = params[:other][:amount]
        if amount == ""
            render action: 'new'
            return
        end
        (amount.to_i).times do 
            @bottle = Bottle.new(create_params)
            if !@bottle.save 
                render action: 'new'
                return
            end
        end
        flash[:notice] = "Successfully created bottles for patient."
        redirect_to patient_path(@bottle.patient), notice: flash[:notice] # go to show bottle page
    end

    def edit
        authorize! :edit, @bottle
    end

    def show  
        
    end

    def update
        authorize! :update, @bottle
        if ActiveModel::Type::Boolean.new.cast(params[:other][:confirm])
            @bottle.storage_location = @bottle.storage_location.downcase == "fridge" ? "Freezer" : "Fridge"
            @bottle.save
            flash[:notice] = "Updated storage location on bottle."
            redirect_to patient_path(@bottle.patient), notice: flash[notice]
        else 
            redirect_to patient_path(@bottle.patient)
        end
    end

    def delete 
        authorize! :destroy, @bottle
    end 

    def destroy
        authorize! :destroy, @bottle
        if ActiveModel::Type::Boolean.new.cast(params[:other][:confirm])
            path = @bottle.get_qr_path
            puts path
            File.delete(path) if File.exist?(path)
            @patient = @bottle.patient
            @bottle.destroy
            flash[:notice] = "Removed bottle for #{@patient.proper_name} from the system."
            redirect_to patient_path(@patient), notice: flash[:notice]
        else 
            flash[:error] = "Deletion cancelled."
            redirect_to patient_path(@bottle.patient), error: flash[:error]
        end
        
    end

    def reprint
        @bottle.print_qr
        flash[:notice] = "Reprinted."
        redirect_to bottle_path(@bottle), notice: flash[:notice]
    end

    
    private
    def set_bottle
        @bottle = Bottle.find(params[:id])
    end


    def create_params
        params.require(:bottle).permit(:patient_id, :checkin_nurse_id_id, :collected_date, :storage_location)
    end
end
