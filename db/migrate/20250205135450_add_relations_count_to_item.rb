class AddRelationsCountToItem < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :relations_count, :integer, null: false, default: 0
  end
end
