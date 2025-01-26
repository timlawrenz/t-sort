class AddComboIndexOnItems < ActiveRecord::Migration[8.0]
  def change
    add_index :relations, %i[item1_id item2_id], unique: true
  end
end
