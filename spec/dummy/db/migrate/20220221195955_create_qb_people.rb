class CreateQbPeople < ActiveRecord::Migration[6.1]
  def change
    create_view :qb_people
  end
end
