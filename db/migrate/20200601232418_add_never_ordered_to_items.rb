class AddNeverOrderedToItems < ActiveRecord::Migration[5.1]
  def change
    add_column :items, :never_ordered, :boolean, default: true
  end
end
