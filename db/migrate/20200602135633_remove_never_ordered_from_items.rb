class RemoveNeverOrderedFromItems < ActiveRecord::Migration[5.1]
  def change
    remove_column :items, :never_ordered?, :boolean
  end
end
