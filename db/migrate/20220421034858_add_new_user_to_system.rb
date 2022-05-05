class AddNewUserToSystem < ActiveRecord::Migration[5.2]
  def up
        
      admin = User.new
      admin.first_name = "Admin"
      admin.last_name = "Admin"
      admin.username = "admin@default.com"
      admin.password = "admin101"
      admin.password_confirmation = "admin101"
      admin.role = "admin"
      admin.save!
      nurse = User.new
      nurse.first_name = "Nurse"
      nurse.last_name = "Nurse"
      nurse.username = "nurse@default.com"
      nurse.password = "secretNurse"
      nurse.password_confirmation = "secretNurse"
      nurse.role = "nurse"
      nurse.save!
  end
  def down
      admin = User.find_by_username "admin@default.com"
      User.delete admin
      nurse = User.find_by_username "nurse@default.com"
      User.delete nurse
  end

  
end
