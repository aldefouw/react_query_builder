module ReactQueryBuilder

  class QueryReport

    def initialize(run_query:,
                   use_saved_params:,
                   params:,
                   form_path:,
                   include_data:)
      @params = params
      @query_params = QueryParams.new(params: params, include_data: include_data).params
      @use_saved_params = use_saved_params
      @form_path = form_path
      @run_query = run_query
      @include_data = include_data
      @query = query
    end

    def query
      @params[:id] && @use_saved_params ?
        QbSavedQuery.find_by(id: @params[:id]) :
        QbSavedQuery.new(@query_params)
    end

    def title
      "#{@params[:id] ? "Edit" : "New"} #{report.title} Query" if report.present?
    end

    def search
      if @query.present?
        r = report.ransack(search_params)
        r.build_grouping unless r.groupings.any?
        r
      end
    end

    def path
      @form_path
    end

    def labels
      report.labels if @query.present?
    end

    def report
      @query.current_query if @query.present?
    end

    def columns
      @params[:display_fields]
    end

    def run_query
      @run_query if @query.present?
    end

    def query_params
      if @query.present?
        @params[:q] ? @params[:q].to_json : @query.q
      end
    end

    def data
      report.results(search) if @include_data
    end

    def include_data
      @include_data
    end

    def search_params
      @use_saved_params && @query.present? ?
        JSON.parse(@query.q) :
        @query_params[:q]
    end

  end

end