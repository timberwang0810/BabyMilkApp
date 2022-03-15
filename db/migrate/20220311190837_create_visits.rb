class CreateVisits < ActiveRecord::Migration[5.2]
  def change
    create_table :visits do |t|
      t.references :patient, foreign_key: true
      t.string :account_number
      t.date :admission_date
      t.date :discharge_date

      t.timestamps
    end
  end
end
