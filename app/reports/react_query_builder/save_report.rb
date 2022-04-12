module ReactQueryBuilder

	class SaveReport

		def initialize(params:, form_path:)
			@params = params
			@path = form_path
			@query_params = QueryParams.new(params: params).params
			@query = QbSavedQuery.new
			@query_form = SaveQueryForm.new(@query)
		end

		def query
			@query
		end

		def query_form
			@query_form
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

		def path
			@path
		end

		private

		def query_form_params
			@params[:react_query_builder_save_query]
		end

		def save_button?
			@params.key?(:commit) &&
			!@params[:commit].include?("Save As") &&
			!@params[:commit].include?("Save Query") &&
			@params[:commit].include?("Save")
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
			@query = QbSavedQuery.find_by(id: @params[:id])
			@query.update(@query_params.except!(:query_type)) if @query.present?
			@query
		end

	end

end