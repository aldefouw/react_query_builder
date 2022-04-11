module ReactQueryBuilder

	class SaveReport < ApplicationController

		def initialize(params:, form_path:)
			@params = params
			@query = ReactQueryBuilder::QbSavedQuery.new
			@query_form = ReactQueryBuilder::SaveQueryForm.new(@query)
			@path = form_path
			@options = set_params
			params_for_save
		end

		def set_params
			cols = Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = Array.new}}
			@params[:display_fields].each { |c| cols[c] = "1" } unless @params[:display_fields].nil?
			{
				display_fields: @params[:display_fields].nil? ? {} : cols.to_json,
				q: @params[:q],
				query_type: @params[:query_type]
			}
		end

		def query
			@query
		end

		def query_form
			@query_form
		end

		def params_for_save
			@params_for_save = @options
			@params_for_save[:q] = @params_for_save[:q].nil? ? {} : @params_for_save[:q].to_json
		end

		def path
			@path
		end

		def query_form_params
			@params[:react_query_builder_save_query]
		end

		def save_button?
			@params[:commit] == "Save  "
		end

		def save_as_query_criteria?
			query_form_params.present? && @query_form.validate(query_form_params) && !save_button?
		end

		def save_query_criteria?
			update_page && save_button? && @params[:id].present?
		end

		def update_page
			@params[:action] == "update"
		end

		def save_as_query_to_db
			@query_form.save
			@query_form
		end

		def save_query_to_db
			@query = ReactQueryBuilder::QbSavedQuery.find_by(id: @params[:id])
			@query.update(q: @params_for_save[:q], display_fields: @params_for_save[:display_fields]) if @query.present?
			@query
		end

		def attempt_save
			if save_as_query_criteria?
				save_as_query_to_db
			elsif save_query_criteria?
				save_query_to_db
			else
				false
			end
		end

	end

end