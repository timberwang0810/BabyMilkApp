class AddAdmittedToPatient < ActiveRecord::Migration[5.2]
  def change
      add_column :patients, :admitted, :boolean, default: false
  end
end
