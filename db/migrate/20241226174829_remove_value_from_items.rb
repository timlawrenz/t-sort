class RemoveValueFromItems < ActiveRecord::Migration[8.0]
  def change
    remove_column :items, :value
  end
end
