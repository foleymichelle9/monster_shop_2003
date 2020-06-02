class ChagneNeverOrderedName < ActiveRecord::Migration[5.1]
  def change
    rename_column :items, :never_ordered, :never_ordered?
  end
end
