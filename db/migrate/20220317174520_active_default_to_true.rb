class ActiveDefaultToTrue < ActiveRecord::Migration[5.2]
  def change
    change_column_default :patients, :active, true
    change_column_default :users, :active, true
    change_column_default :bottles, :active, true
  end
end
