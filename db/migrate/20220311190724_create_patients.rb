class CreatePatients < ActiveRecord::Migration[5.2]
  def change
    create_table :patients do |t|
      t.string :patient_mrn
      t.string :first_name
      t.date :dob
      t.string :last_name
      t.integer :age
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
