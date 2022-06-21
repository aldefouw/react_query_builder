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

		remove_column("Id")

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

	scenario 'If I save my specific query, I am able to visit it again' do
		visit 'query_builder/new?query_type=qb_person'

		remove_column("Id")
		remove_column("Middle Name")

		click_on "Run Query"

		#Needs to be wrapped to accept Javascript confirmation
		page.accept_confirm { click_button "Save" }

		#Attempt to save a query without a title - shouldn't be allowed!
		click_on "Save Query"
		expect(page).not_to have_content("Title Description Last Run User Action")

		#Let's do it right now - Save Query
		fill_in "Title", with: "First & Last Name Only"
		fill_in "Description", with: "A test query to make sure it saves for us."
		click_on "Save Query"

		#Now it's okay to expect this
		expect(page).to have_content("Title Description Last Run User Action")

		#We should also see this
		expect(page).to have_content("First & Last Name Only")
		expect(page).to have_content("A test query to make sure it saves for us.")
	end

	scenario 'I am able to edit a saved query and save it as another query' do
		visit 'query_builder'

		#Click the last Run button
		all('.rqb_run_btn').last.click

		#Check for the expected buttons
		expect(page).to have_content 'Edit Report'
		expect(page).to have_content 'Export CSV'
		expect(page).to have_content 'Export Excel'

		#Click to Edit Report
		click_on "Edit Report"
		expect(page).to have_content "Edit Person Query"

		#Select All Columns
		click_on "Select All"

		#Needs to be wrapped to accept Javascript confirmation
		page.accept_confirm { click_button "Save As" }

		#Let's do it right now - Save Query
		fill_in "Title", with: "All Fields"
		fill_in "Description", with: "A query with all fields saved"
		click_on "Save Query"

		#We should also see this
		expect(page).to have_content("All Fields")
		expect(page).to have_content("A query with all fields saved")

		#Run the last report
		all('.rqb_run_btn').last.click

		#Expect these column headers
		expect(page).to have_content("Id")
		expect(page).to have_content("First Name")
		expect(page).to have_content("Middle Name")
		expect(page).to have_content("Last Name")

		#Expect to see all of this column data
		expect(react_table_html).to have_content(Person.last.id)
		expect(react_table_html).to have_content(Person.last.first_name)
		expect(react_table_html).to have_content(Person.last.middle_name)
		expect(react_table_html).to have_content(Person.last.last_name)
	end

	scenario 'If I sort a numerical column, it is sorted numerically' do
		visit 'query_builder'

		#steps for numeric sort

	end

	scenario 'If I create a query, save it, and then edit it, it works' do
		visit 'query_builder'

		#Click the last Run button
		all('.rqb_run_btn').last.click

		#Check for the expected buttons
		expect(page).to have_content 'Edit Report'
		expect(page).to have_content 'Export CSV'
		expect(page).to have_content 'Export Excel'

		#Click to Edit Report
		click_on "Edit Report"
		expect(page).to have_content "Edit Person Query"

		#Select All Columns
		click_on "Select All"

		#Needs to be wrapped to accept Javascript confirmation
		page.accept_confirm { click_button "Save As" }

		#Let's do it right now - Save Query
		fill_in "Title", with: "All Fields"
		fill_in "Description", with: "A query with all fields saved"
		click_on "Save Query"

		#We should also see this
		expect(page).to have_content("All Fields")
		expect(page).to have_content("A query with all fields saved")

		#Edit the last report
		all('.rqb_edit_btn').last.click

		#Check for the expected buttons
		expect(page).to have_content 'Edit Person QUery'
		expect(page).to have_content 'All Fields'
		expect(page).to have_content 'Export CSV'
		expect(page).to have_content 'Export Excel'
	end

end