class CreateBottles < ActiveRecord::Migration[5.2]
  def change
    create_table :bottles do |t|
      t.references :patient, foreign_key: true
      #t.references :checkin_nurse_id
      #t.references :checkout_nurse_id
      t.datetime :collected_date
      t.string :storage_location
      t.datetime :administration_date
      t.datetime :expiration_date
      t.boolean :active, default: true

      t.timestamps
    end
    
    #add_foreign_key :bottles, :users, column: :checkin_nurse_id
    #add_foreign_key :bottles, :users, column: :checkout_nurse_id
  end
end
