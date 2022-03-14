require 'spec_helper'

RSpec.describe 'Creating, Editing, and Removing a Person Query', type: :feature do

	let(:react_table_html) { find('div.ReactTable div.rt-table') }
	
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

		expect(react_table_html).to have_content(Person.first.first_name)
		expect(react_table_html).to have_content(Person.first.middle_name)
		expect(react_table_html).to have_content(Person.first.last_name)
	end

	scenario 'I run a New Person Query with criteria specified for a specific person' do
		visit 'query_builder/new?query_type=qb_person'

		click_on "Add Query Criteria"

		chosen_select('div#qb_attribute_select_chosen', "Last Name")
		chosen_select('div#qb_predicates_chosen', "equals")
		find('div.fields input.form-control').set(Person.last.last_name)

		click_on "Run Query"

		expect(react_table_html).to have_content(Person.last.first_name)
		expect(react_table_html).to have_content(Person.last.middle_name)
		expect(react_table_html).to have_content(Person.last.last_name)

		if Person.last.last_name != Person.first.last_name
			expect(react_table_html).not_to have_content(Person.first.first_name)
			expect(react_table_html).not_to have_content(Person.first.middle_name)
			expect(react_table_html).not_to have_content(Person.first.last_name)
		end
	end

	scenario 'I reorganize the order of fields and display table reflects this' do
		visit 'query_builder/new?query_type=qb_person'

		#Establish initial column order
		click_on "Run Query"
		expect(react_table_html).to have_content("Id\nLast Name\nFirst Name\nMiddle Name")

		first_name_col = find(text: 'First Name', class: 'search-choice')
		last_name_col = find(text: 'Last Name', class: 'search-choice')

		first_name_col.drag_to(last_name_col)

		#See if the order has changed in the output after we run the query
		click_on "Run Query"
		expect(react_table_html).to have_content("Id\nFirst Name\nLast Name\nMiddle Name\n")
	end

	scenario 'I remove a column from the list of columns displayed and display table reflects this' do
		visit 'query_builder/new?query_type=qb_person'

		#Establish initial columns displayed
		click_on "Run Query"
		expect(react_table_html).to have_content("Id\nLast Name\nFirst Name\nMiddle Name")

		id = find(text: 'Id', class: 'search-choice') #Find the ID field
		within(id){ find('a') }.click #Click on the "X" on the "Id" field

		#See if the order has changed in the output after we run the query
		click_on "Run Query"
		expect(react_table_html).to have_content("Last Name\nFirst Name\nMiddle Name\n")
		expect(react_table_html).not_to have_content("Id\nLast Name\nFirst Name\nMiddle Name\n")
	end

	scenario 'I remove all columns from the list of available columns' do
		visit 'query_builder/new?query_type=qb_person'

		#Establish initial columns displayed
		click_on "Run Query"
		expect(page).to have_content("Id\nLast Name\nFirst Name\nMiddle Name")

		click_on "Clear All"

		#See if the order has changed in the output after we run the query
		click_on "Run Query"

		#Have to use "page" here instead of "react_table_html" because the latter does not exist.
		expect(page).not_to have_content("Id\nLast Name\nFirst Name\nMiddle Name\n")
	end

	scenario 'I add all columns to the list of available columns' do
		visit 'query_builder/new?query_type=qb_person'

		#Establish initial columns displayed
		click_on "Clear All"

		#See if the order has changed in the output after we run the query
		click_on "Run Query"

		#Have to use "page" here instead of "react_table_html" because the latter does not exist.
		expect(page).not_to have_content("Id\nLast Name\nFirst Name\nMiddle Name\n")

		#Establish initial columns displayed
		click_on "Select All"

		#See if the order has changed in the output after we run the query
		click_on "Run Query"
		expect(page).to have_content("Id\nLast Name\nFirst Name\nMiddle Name")
	end

end