class ScanbottleController < ApplicationController
  before_action :check_login
  def index
  end

  def edit
    authorize! :edit, Bottle 
  end

  def update
    authorize! :update, Bottle
    bottle_id_enc = params[:other][:bottle_id]
    if bottle_id_enc.length != 16 or !(is_integer?(Bottle.get_bottle_id(bottle_id_enc)))
        flash[:error] = "Please scan a valid bottle QR code."
        render action: 'edit', error: flash[:error]
        return
    end
    bottle = Bottle.find(Bottle.get_bottle_id(bottle_id_enc))
    if bottle != nil 
        redirect_to edit_bottle_path(bottle)
    else 
        flash[:error] = "Bottle doesn't exist, or has already been thrown out!"
        render action: 'edit', error: flash[:error]
    end
  end

  def delete
    authorize! :destroy, Bottle
  end

  def destroy
    authorize! :destroy, Bottle
    bottle_id_enc = params[:other][:bottle_id]
    if bottle_id_enc.length != 16 or !(is_integer?(Bottle.get_bottle_id(bottle_id_enc)))
        puts bottle_id_enc.length
        flash[:error] = "Please scan a valid bottle QR code."
        render action: 'edit', error: flash[:error]
        return
    end
    if Bottle.exists?(Bottle.get_bottle_id(bottle_id))
      bottle = Bottle.find(Bottle.get_bottle_id(bottle_id_enc))
      redirect_to delete_bottle_path(bottle)
    else 
      flash[:error] = "Bottle doesn't exist, or has already been thrown out!"
      render action: 'delete', error: flash[:error]
    end
  end

  private 
  def is_integer?(str)
    str.to_i.to_s == str
  end
end
