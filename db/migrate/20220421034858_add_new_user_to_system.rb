class AddNewUserToSystem < ActiveRecord::Migration[5.2]
  def up
        
      admin = User.new
      admin.first_name = "Admin"
      admin.last_name = "Admin"
      admin.username = "admin@hahaha.com"
      admin.password = "secret"
      admin.password_confirmation = "secret"
      admin.role = "admin"
      admin.save!
      nurse = User.new
      nurse.first_name = "Nurse"
      nurse.last_name = "Nurse"
      nurse.username = "nurse@hahaha.com"
      nurse.password = "secretNurse"
      nurse.password_confirmation = "secretNurse"
      nurse.role = "nurse"
      nurse.save!
  end
  def down
      admin = User.find_by_username "admin@hahaha.com"
      User.delete admin
      nurse = User.find_by_username "nurse@hahaha.com"
      User.delete nurse
  end

  
end
