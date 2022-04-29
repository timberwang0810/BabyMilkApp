class RemoveUserFromBottles < ActiveRecord::Migration[5.2]
  def change
      remove_foreign_key :bottles, name: "checkin_nurse_id_id"
      remove_foreign_key :bottles, name: "checkout_nurse_id_id"
  end
end
