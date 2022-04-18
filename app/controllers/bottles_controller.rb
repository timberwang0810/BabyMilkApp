class BottlesController < ApplicationController
    before_action :set_bottle, only: [:show, :edit, :update, :destroy]
    def index
        @active_bottles = Bottle.active.by_patient.paginate(page: params[:page]).per_page(15)
    end

    def new
        @bottle = Bottle.new
    end

    def create
        puts params[:other][:amount]
        amount = params[:other][:amount].to_i
        amount.times do 
            @bottle = Bottle.new(bottle_params)
            if !@bottle.save 
                render action: 'new'
            end
        end
        flash[:notice] = "Successfully created bottles for patient."
        redirect_to patient_path(@bottle.patient) # go to show bottle page
        # @bottle = Bottle.new(bottle_params)
        # if @bottle.save
        #     # if saved to database
        #     flash[:notice] = "Successfully created bottle."
        #     redirect_to bottle_path(@bottle) # go to show bottle page
        # else
        #     # return to the 'new' form
        #     render action: 'new'
        # end
    end

    def edit
    end

    def show  
    end

    def update
        if @bottle.update_attributes(bottle_params)
            flash[:notice] = "Updated all information on bottle"
            redirect_to @bottle
        else
            render action: 'edit'
        end
    end

    def destroy
        @bottle.destroy
        flash[:notice] = "Removed bottle from the system"
        redirect_to bottles_url, notice: flash[:notice]
    end

    
    private
    def set_bottle
        @bottle = Bottle.find(params[:id])
    end


    def bottle_params
        params.require(:bottle).permit(:patient_id, :checkin_nurse_id_id, :checkout_nurse_id_id, :collected_date, :storage_location, :administration_date, :expiration_date)
    end
end
