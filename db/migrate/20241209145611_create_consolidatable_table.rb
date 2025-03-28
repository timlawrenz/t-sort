class CreateConsolidatableTable < ActiveRecord::Migration[8.0]
  def self.up
    create_table 'consolidations' do |t|
      t.bigint 'consolidatable_id', null: false
      t.string 'consolidatable_type', null: false
      t.string 'var_name', null: false
      t.string 'var_type', null: false
      t.float 'float_value'
      t.bigint 'integer_value'
      t.boolean 'boolean_value'
      t.string 'string_value'
      t.datetime 'datetime_value'

      t.timestamps
    end

    add_index 'consolidations', ['consolidatable_id',
                                 'consolidatable_type',
                                 'var_name'],
                                name: :consolidations_main_index

  end
  
  def self.down
    drop_table 'consolidations'
  end
end
