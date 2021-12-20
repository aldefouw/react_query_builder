# -------------------------------
#    QueryBuilderDisplayHelper 
# -------------------------------
# => Display fields (checkboxes)
# => Results table (React table)


module QueryBuilderDisplayHelper

  # Accepts a list of model attributes & returns hash of attribute and label for checkboxes 
  def display_fields
    select_list.map { |x| { attribute_name: x.first, label: x.second } }
  end

  def select_list
    if @cols.present? && params[:action] != "edit"
      posted_columns(@cols)
    elsif params[:action] == "edit"
      posted_columns(JSON.parse(@query.display_fields).keys)
    else
      existing_columns
    end
  end

  def posted_columns(cols)
    options = {}
    cols.each { |c| options[c] = @report.labels[c] }
    @report.labels.keys.each { |l| options[l] = @report.labels[l] unless cols.include?(l) }
    options
  end

  def existing_columns
    @report.labels
  end

  def display_select(items)
    select_tag(:display_fields,
             options_for_select(items.map{ |s| [s[:label], s[:attribute_name]] }, selected: selected),
             multiple: true,
             class: "chosen-select chosen-sortable")
  end

  def selected
    if params[:action] == "edit"
      JSON.parse(@query.display_fields).keys
    elsif JSON.parse(@query.display_fields).map(&:first).count > 0
      JSON.parse(@query.display_fields).map(&:first)
    elsif params[:action] == "new"
      @report.labels.keys #Show all when you come to a new query
    else
      params[:display_fields]
    end
  end

end