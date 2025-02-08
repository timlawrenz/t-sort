class AddIndexOnItemsRelationsCount < ActiveRecord::Migration[8.0]
  def change
    add_index :items, :relations_count
  end
end
