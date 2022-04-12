module ReactQueryBuilder

  class QueryParams

    def initialize(params:, include_data: false)
      @params = params
      @query_params = include_data ? get_params : set_params
    end

    def params
      @query_params
    end

    private

    def set_params
      cols = Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = Array.new}}
      @params[:display_fields].each{|c| cols[c] = "1"} unless @params[:display_fields].nil?
      {
        display_fields: @params[:display_fields].nil? ? {} : cols.to_json,
        q: @params[:q].nil? ? {} : @params[:q].to_json,
        query_type: @params[:query_type]
      }
    end

    def get_params
      {
        display_fields: @params[:display_fields].nil? ? {} : @params[:display_fields],
        q: @params[:q].nil? ? {} : JSON.parse(@params[:q]),
        query_type: @params[:query_type]
      }
    end

  end

end