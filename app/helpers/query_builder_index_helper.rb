# -------------------------------
#     QueryBuilderIndexHelper 
# -------------------------------
# => Index age/query manager user interface
# => Saved query tables

module QueryBuilderIndexHelper

# *********************************************** 
#   QUERY MANAGER/INDEX PAGE/SAVED QUERY TABLES   
# *********************************************** 

# => A single row of a saved query table on index page
  def saved_query_index_table_row(query)
    td_toolbar = query_action_toolbar(query)
    td_title = content_tag(:td, query.title)
    td_description = content_tag(:td, query.description)
    td_last_run_date = content_tag(:td, query.last_run)
    td_last_run_by = content_tag(:td, query.last_run_by)
    content_tag(:tr, td_title + td_description + td_last_run_date + td_last_run_by + td_toolbar)
  end

  # => Button toolbar for a saved query on index page
  #     - 'Run query' button and 'delete query' button
  def query_action_toolbar(query)
    run_button = link_to "<i class=\"fas fa-bolt\"></i>&nbsp;Run".html_safe,
                         query_builder_path(id: query.id),
                         class: 'btn btn-sm btn-info mr-1 rqb_btn rqb_run_btn '

    edit_button = link_to "<i class=\"fas fa-edit\"></i>&nbsp;Edit".html_safe,
                          edit_query_builder_path(id: query.id),
                          class: 'btn btn-sm btn-primary mr-1 rqb_btn rqb_edit_btn'

    delete_button = link_to "<i class=\"fas fa-trash-alt\"></i>".html_safe,
                            query_builder_path(id: query.id),
                            method: :delete,
                            data: {confirm: "Are you sure you want to delete this query?"},
                            class: 'btn btn-sm btn-danger rqb_btn rqb_delete_btn'

    button_div = content_tag(:div, run_button + edit_button + delete_button)
    td_toolbar = content_tag(:td, button_div)
  end

  def selected_query(index, report)
    index == 0 && !params.key?(:query_type) || (params.key?(:query_type) && report[:model].underscore == params[:query_type])
  end

end