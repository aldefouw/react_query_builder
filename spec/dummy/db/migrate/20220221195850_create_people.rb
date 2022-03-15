class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name

      t.boolean :active
      t.boolean :trained

      t.time :account_timeout

      t.integer :status

      t.timestamps
    end
  end
end
