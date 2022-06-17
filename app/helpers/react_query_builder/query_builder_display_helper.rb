module ReactQueryBuilder

  module QueryBuilderDisplayHelper

    # Accepts a list of model attributes & returns hash of attribute and label for checkboxes
    def display_fields
      select_list.map { |x| { attribute_name: x.first, label: x.second } }
    end

    def new_query?
      params[:action] == "new"
    end

    def edit_query?
      params[:action] == "edit"
    end

    def existing_report?
      existing_report_columns.count > 0
    end

    def parsed_display_fields
      JSON.parse(@query.display_fields)
    end

    def new_query_columns
      report_keys
    end

    def edit_query_columns
      parsed_display_fields.is_a?(Array) ?
        parsed_display_fields :
        parsed_display_fields.keys
    end

    def existing_report_columns
      parsed_display_fields.map(&:first)
    end

    def report_labels
      @query_report.labels
    end

    def report_keys
      report_labels.keys
    end

    def posted_columns?
      @query_report.columns.present? || edit_query?
    end

    def select_posted_columns
      edit_query? ?
        edit_query_columns :
        @query_report.columns
    end

    def select_list
      posted_columns? ?
        posted_columns(select_posted_columns) :
        report_labels
    end

    def posted_columns(cols)
      options = {}
      cols.each { |c| options[c] = report_labels[c] }
      report_keys.each { |l| options[l] = report_labels[l] unless cols.include?(l) }
      options
    end

    def display_select(items)
      select_tag(:display_fields,
                 options_for_select(items.map{ |s| [s[:label], s[:attribute_name]] }, selected: selected),
                 multiple: true,
                 class: "chosen-select chosen-sortable")
    end

    def selected
      if edit_query?
        edit_query_columns
      elsif existing_report?
        existing_report_columns
      elsif new_query?
        new_query_columns
      else
        params[:display_fields]
      end
    end

  end

end