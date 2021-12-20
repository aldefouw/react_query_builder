class CreateQbFieldMappings < ActiveRecord::Migration[6.1]
  def change
    create_table :qb_field_mappings do |t|
      t.string :model
      t.text :labels
      t.timestamps
    end
  end
end
