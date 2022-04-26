class AddPasswordResetColumnsToUser < ActiveRecord::Migration[5.2]
  add_column :users, :reset_password_token, :string
  add_column :users, :reset_password_sent_at, :datetime
end
