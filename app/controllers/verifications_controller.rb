class VerificationsController < ApplicationController
    before_action :set_verification, only: [:success, :failed, :expired]
    before_action :check_login  
    def new
      @verifier = Verification.new
    end

    def create
        @verifier = Verification.new
        bottle_id = verification_params[:bottle_id]
        patient_id = verification_params[:patient_id]
        if !Bottle.exists?(Bottle.get_bottle_id(bottle_id))
          flash[:error] = "Bottle doesn't exist, or has already been thrown out!"
          render action: 'new', error: flash[:error]
          return
        end 
        @bottle = Bottle.find(Bottle.get_bottle_id(bottle_id))
        
        @visit = Visit.where(account_number: patient_id)
        if @visit.empty?
          flash[:error] = "Patient doesn't exist!"
          render action: 'new', error: flash[:error]
          return
        end
        @patient = @visit.first.patient
        if !(@visit.first.is_active?)
          flash[:error] = "Patient is already discharged!"
          render action: 'new', error: flash[:error]
          return
        end
        @verifier.bottle_id = bottle_id
        @verifier.patient_id = patient_id
        if @verifier.verify && !@verifier.expired
          redirect_to success_path(@patient, @bottle)
        elsif @verifier.verify && @verifier.expired
          redirect_to expired_path(@patient,@bottle)
        else
          redirect_to failed_path(@patient, @bottle)
        end
    end

    def success
    end

    def failed
    end

    def expired
    end

    private
    def set_verification
      @patient = Patient.find(params[:patient_id])
      @bottle = Bottle.find(params[:bottle_id])
    end

    def verification_params
        params.require(:verification).permit(:patient_id, :bottle_id)
    end
  end