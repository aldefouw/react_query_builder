require 'rails_helper'

RSpec.describe 'Creating a Person Query', type: :feature do

	scenario 'I visit Query Builder Dashboard' do
		visit '/query_builder'

		expect(html).to have_content 'Query Builder'
		expect(html).to have_content 'New Query'
		expect(html).to have_content 'Person'
	end

	scenario 'I click on New Query button' do
		visit '/query_builder'
		click_on "New Query"

		expect(html).to have_content 'New Person Query'
		expect(html).to have_content 'Query Field Mappings'
		expect(html).to have_content 'Display Fields'
		expect(html).to have_content 'Back'
		expect(html).to have_content 'Add Query Criteria'
		expect(html).to have_content 'Add Nested Grouping'
		expect(html).to have_content 'Remove Group'
		expect(html).to have_content 'Select All'
	end

	scenario 'I create a New Query' do
		visit 'query_builder/new?query_type=qb_person'
		click_on "Run Query"
		expect(html).to have_content "No rows found"
	end

end