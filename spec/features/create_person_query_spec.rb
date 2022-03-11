require 'spec_helper'

RSpec.describe 'Creating a Person Query', type: :feature do

	scenario 'I visit Query Builder Dashboard and see the expected items' do
		visit '/query_builder'

		expect(html).to have_content 'Query Builder'
		expect(html).to have_content 'New Query'
		expect(html).to have_content 'Person'
	end

	scenario 'I click on New Query button and see the expected buttons' do
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

	scenario 'I run a New Person Query without any criteria' do
		visit 'query_builder/new?query_type=qb_person'
		click_on "Run Query"

		expect(find('div.ReactTable div.rt-table')).to have_content(Person.first.first_name)
		expect(find('div.ReactTable div.rt-table')).to have_content(Person.first.middle_name)
		expect(find('div.ReactTable div.rt-table')).to have_content(Person.first.last_name)
	end

	scenario 'I run a New Person Query with criteria specified for a specific person' do
		visit 'query_builder/new?query_type=qb_person'

		click_on "Add Query Criteria"

		chosen_select('div#qb_attribute_select_chosen', "Last Name")
		chosen_select('div#qb_predicates_chosen', "equals")
		find('div.fields input.form-control').set(Person.last.last_name)

		click_on "Run Query"

		expect(find('div.ReactTable div.rt-table')).to have_content(Person.last.first_name)
		expect(find('div.ReactTable div.rt-table')).to have_content(Person.last.middle_name)
		expect(find('div.ReactTable div.rt-table')).to have_content(Person.last.last_name)

		if Person.last.last_name != Person.first.last_name
			expect(find('div.ReactTable div.rt-table')).not_to have_content(Person.first.first_name)
			expect(find('div.ReactTable div.rt-table')).not_to have_content(Person.first.middle_name)
			expect(find('div.ReactTable div.rt-table')).not_to have_content(Person.first.last_name)
		end
	end

end