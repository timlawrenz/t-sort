class AddSortableToItem < ActiveRecord::Migration[7.2]
  def change
    add_column :items, :sortable_id, :integer
    add_column :items, :sortable_type, :string
    add_index :items, [:sortable_id, :sortable_type]
  end
end
