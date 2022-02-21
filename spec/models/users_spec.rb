require 'spec_helper'

RSpec.describe User, type: :model do
	it "Is a valid user" do
		user = User.create(name: "Don")
		expect(user.valid?).to eq(true)
	end
end