module ReactQueryBuilder

	class RunReport < QueryReport

		def initialize(run_query: true,
		               use_saved_params: false,
		               params:,
		               form_path: nil,
		               include_data: false)
			super
			@run_query = @params[:display_fields] ? true : false if @query.present?
		end

	end

end