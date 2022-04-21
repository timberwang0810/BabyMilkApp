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
  end
  def down
      admin = User.find_by_username "admin@hahaha.com"
      User.delete admin
  end

  
end
