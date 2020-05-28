class ChangeZipToBeIntegerInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :zip, :integer
  end
end
