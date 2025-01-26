class AddPostableToPictures < ActiveRecord::Migration[7.2]
  def change
    add_column :pictures, :postable, :boolean, default: true
    add_index :pictures, :postable
  end
end
