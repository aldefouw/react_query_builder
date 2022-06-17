module ReactQueryBuilder

  class QueryBuilderController < ApplicationController

    def index
      @queries = QbSavedQuery.all
      @reports = QueryBuilder.reports
    end

    def new
      QueryBuilder.report_included?(params[:query_type]) ?
        query_report(type: __method__) :
        redirect_to(rqb.query_builder_index_path)
    end

    def create
      respond_to do |format|
        format.html do
          update_and_save
        end

        format.json do
          query_report(type: __method__, format: :json, render: false)
          render json: result_data.map { |row| @query.display_row(row) } if @query_report.include_data
        end
      end
    end

    def edit
      query_report(type: __method__)
    end

    def update
      update_and_save
    end

    def show
      query_report(type: __method__, render: false)
    end

    def destroy
      @query = QbSavedQuery.find_by(id: params[:id])
      if @query.nil?
        flash[:warning] = "This query does not exist."
        redirect_to rqb.query_builder_index_path
      else
        @query.delete
        flash[:success] = "#{@query.title} query successfully deleted."
        redirect_to rqb.query_builder_index_path(query_type: @query.query_type)
      end
    end

    private

    def update_and_save
      if params[:commit].present? && params[:commit].include?("Save Field Mappings")
        save_field_mappings
      elsif params[:commit].present? && params[:commit].include?("Run Query")
        query_report(type: 'run')
      else
        save_report
      end
    end

    def rqb
      react_query_builder_rails_engine
    end

    def save_field_mappings
      @mapping = QbFieldMapping.find_by(model: params[:query_type].classify)
      qfm = @mapping.update(labels: params[:field_mapping])
      flash[:success] = "Query Field Mappings successfully updated." if qfm
      redirect_to params[:action] == "update" ?
                    rqb.edit_query_builder_path(id: params[:id]) :
                    rqb.new_query_builder_path(query_type: params[:query_type])
    end

    def save_report
      @save_report = SaveReport.new(params: params, form_path: form_path)
      saved_query = @save_report.attempt_save

      if saved_query.present?
        @save_report.query.set_last_run_time(user: defined?(current_user) ? current_user : nil)
        flash[:success] = "Query was successfully saved."
      elsif saved_query === false
        return render 'save_query'
      end

      redirect_to rqb.query_builder_index_path(@save_report.query.present? ? {query_type: @save_report.query.query_type} : {})
    end

    def query_report(type:, render: true, format: :html)
      @query_report = current_report(type: type, format: format).new(form_path: form_path, params: params)
      @query = @query_report.query
      @report = @query_report.report
      @search = @query_report.search
      return redirect_to rqb.query_builder_index_path if params[:id] && @query.nil?
      render 'query_form' if render
    end

    def result_data
      @query_report.data
    end

    def current_report(type:, format:)
      "ReactQueryBuilder::#{type.to_s.titleize}#{format == :json ? "Json" : ""}Report".constantize
    end

    def form_path
      params[:id] ?
        { url: rqb.query_builder_path(id: params[:id]), html: { method: :patch } } :
        { url: rqb.query_builder_index_path, html: { method: :post }  }
    end

  end

end