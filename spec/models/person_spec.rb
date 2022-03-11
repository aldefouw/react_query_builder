require 'spec_helper'

RSpec.describe Person, type: :model do
	it "creates a valid Person" do
		person = Person.create(first_name: Faker::Name.first_name, last_name: Faker::Name.first_name)
		expect(person.valid?).to eq(true)
	end
end