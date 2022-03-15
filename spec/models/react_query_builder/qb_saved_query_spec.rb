require 'spec_helper'

RSpec.describe ReactQueryBuilder::QbSavedQuery, type: :model do

	it "creates the field mapping if it does not yet exist" do
		#Remove All Field mappings
		ReactQueryBuilder::QbFieldMapping.destroy_all

		#Create the Saved Query
		ReactQueryBuilder::QbSavedQuery.create(title: "Test",
		                                       description: "This is a test description",
		                                       query_type: "qb_person")

		expect(ReactQueryBuilder::QbFieldMapping.first.labels).to eq({"account_timeout"=>"Account Timeout", "active"=>"Active", "first_name"=>"First Name", "hire_date" => "Hire Date", "id"=>"Id", "last_name"=>"Last Name", "middle_name"=>"Middle Name", "status"=>"Status", "trained"=>"Trained", "username"=>"Username"})
	end

	it "updates the columns available if the view has been updated" do
		#Existing labels that don't match the current view's field / label pairings
		ReactQueryBuilder::QbFieldMapping.first.update(labels: {"old_column" => "Old Column"})

		#Make sure it saved
		expect(ReactQueryBuilder::QbFieldMapping.first.labels).to eq({"old_column" => "Old Column"})

		#Create a new Saved Query
		ReactQueryBuilder::QbSavedQuery.create(title: "Test",
                                           description: "This is a test description",
                                           query_type: "qb_person")

		#Did the saved query update the labels to reflect what the view actually says they are?
		expect(ReactQueryBuilder::QbFieldMapping.first.labels).to eq({"account_timeout"=>"Account Timeout", "active"=>"Active", "first_name"=>"First Name", "hire_date" => "Hire Date", "id"=>"Id", "last_name"=>"Last Name", "middle_name"=>"Middle Name", "old_column" => "Old Column", "status"=>"Status", "trained"=>"Trained", "username"=>"Username"})
	end
end