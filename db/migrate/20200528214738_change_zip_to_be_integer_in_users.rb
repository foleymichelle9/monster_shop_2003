class ChangeZipToBeIntegerInUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :zip, 'integer USING CAST(zip AS integer)'
  end
end
