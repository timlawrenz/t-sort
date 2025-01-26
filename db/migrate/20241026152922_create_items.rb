class CreateItems < ActiveRecord::Migration[7.2]
  def change
    create_table :items do |t|
      t.references :series, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
