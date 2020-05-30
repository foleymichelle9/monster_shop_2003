class ChangeZipToIntegerInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :zip, :integer, using: 'zip::integer'
  end
end
