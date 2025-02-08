class AddRelationsWeightToItem < ActiveRecord::Migration[8.0]
  def change
    add_column :items, :relations_weight, :integer, null: false, default: 0
  end
end
