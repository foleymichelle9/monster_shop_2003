class ChangeZipToBeIntegerInUsers < ActiveRecord::Migration[5.1]
  def change
<<<<<<< HEAD
    change_column :users, :zip, 'integer USING CAST (zip AS integer)'
=======
    change_column :users, :zip, 'integer USING CAST(zip AS integer)'
>>>>>>> master
  end
end
