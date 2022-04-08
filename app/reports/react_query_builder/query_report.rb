module ReactQueryBuilder

	class QueryReport < ApplicationController

		def initialize(run_query: true,
                   use_saved_params: false,
                   params:,
                   form_path:,
                   include_data: false)
			@params = params
			@options = include_data ? get_params : set_params
			@use_saved_params = use_saved_params
			@form_path = form_path
			@run_query = run_query
			@include_data = include_data
			@query = query
		end

		def query
			@params[:id] && @use_saved_params ?
				QbSavedQuery.find_by(id: @params[:id]) :
				QbSavedQuery.new(@options)
		end

		def columns
			@params[:display_fields]
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

		def get_params
			{
				display_fields: @params[:display_fields].empty? ? {} : @params[:display_fields],
				q: @params[:q].empty? ? {} : JSON.parse(@params[:q]),
				query_type: @params[:query_type]
			}
		end

		def data
			report.results(search) if @include_data
		end

		def run_query
			@run_query if @query.present?
		end

		def path
			@form_path
		end

		def title
			if @query.present? && @query.current_query.present?
				"#{@params[:id] ? "Edit" : "New"} #{report.title} Query"
			end
		end

		def search
			if @query.present?
				s = report.ransack(@use_saved_params ? JSON.parse(@query.q) : @options[:q])
				s.build_grouping unless s.groupings.any?
				s
			end
		end

		def report
			@query.current_query if @query.present?
		end

		def labels
			report.labels if @query.present?
		end

		def query_params
			if @query.present?
				@params[:q] ? @params[:q].to_json : @query.q
			end
		end

	end

end