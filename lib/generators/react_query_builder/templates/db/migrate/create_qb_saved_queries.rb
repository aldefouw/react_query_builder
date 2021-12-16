class CreateQbSavedQueries < ActiveRecord::Migration[6.1]
  def change
    create_table :qb_saved_queries do |t|
      t.string :title
      t.text :description
      t.text :q
      t.text :display_fields
      t.date :last_run

      t.string :query_type
      t.string :last_run_by
      t.timestamps
    end
  end
end
