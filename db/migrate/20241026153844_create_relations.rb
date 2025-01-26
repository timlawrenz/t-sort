class CreateRelations < ActiveRecord::Migration[7.2]
  def change
    create_table :relations do |t|
      t.bigint :item1_id, null: false, index: true
      t.bigint :item2_id, null: false, index: true

      t.timestamps
    end
    add_foreign_key :relations, :items, column: :item1_id
    add_foreign_key :relations, :items, column: :item2_id
  end
end
