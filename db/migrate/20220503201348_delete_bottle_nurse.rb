class DeleteBottleNurse < ActiveRecord::Migration[5.2]
  def change
      remove_column  :bottles, :checkin_nurse_id_id
      remove_column  :bottles, :checkout_nurse_id_id
  end
end
