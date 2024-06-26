module ReactQueryBuilder

  module QueryBuilderFormHelper

    # Query Form Builder - interacts with Ransack Form Builder
    def setup_search_form(builder)
      fields = builder.grouping_fields builder.object.new_grouping,
                                       object_name: 'new_object_name', child_index: 'new_grouping' do |f|
        render('grouping_fields', f: f)
      end
      content_for :document_ready, %Q{
      var search = new Search({grouping: "#{escape_javascript(fields)}"});
      $(document).on("click", "button.qb_add_fields", function() {
        search.qb_add_fields(this, $(this).data('fieldType'), $(this).data('content'));
        return false;
      });
      $(document).on("click", "button.qb_remove_fields", function() {
        search.qb_remove_fields(this);
        return false;
      });
      $(document).on("click", "button.qb_nest_fields", function() {
        search.qb_nest_fields(this, $(this).data('fieldType'));
        return false;
      });
    }.html_safe
    end

    # Button - adds a single criteria row to query form
    def button_to_add_fields(f, type, button=nil)
      new_object, name = f.object.send("build_#{type}"), "#{type}_fields"
      fields = f.send(name, new_object, child_index: "new_#{type}") do |builder|
        render(name, f: builder)
      end
      tag.button button_labels[button],
                 class: "qb_add_fields btn btn-sm #{button_class[button]} rqb_btn",
                 'data-field-type': type,
                 'data-content': "#{fields}"
    end

    # Button - Removes single query criteria row from Query Form
    def button_to_remove_fields
      btn = tag.button 'Remove', class: "qb_remove_fields btn #{button_class[:remove_fields]}"
      content_tag(:div, btn, class: 'col-2')
    end

    # Button - Removes entire grouping panel from Query Form
    def button_to_remove_grouping
      tag.button 'Remove Group',
                 class: "qb_remove_fields btn btn-sm #{button_class[:remove_group]} float-right rqb_btn rqb_remove_group_btn"
    end

    # Button - Adds a nested grouping panel to Query Form
    def button_to_nest_fields(type, button=nil)
      tag.button button_labels[button],
                 class: "qb_nest_fields btn btn-sm #{button_class[button]} rqb_btn",
                 'data-field-type': type,
                 'data-nest': true
    end

    # Button - Labels for query form buttons
    def button_labels
      { none: '',
        primary_grouping: 'Add Main Grouping',
        nested: 'Add Nested Grouping',
        add_condition: 'Add Query Criteria'
      }.freeze
    end

    # Button - Classes for buttons
    def button_class
      { none: '',
        primary_grouping: 'btn-secondary btn-sm',
        nested: 'btn-secondary btn-sm',
        remove_group: 'btn-danger btn-sm float-right',
        remove_fields: 'btn-danger btn-sm float-right',
        add_condition: 'btn-info btn-sm'
      }.freeze
    end

    # Classes applied to a single query row (attribute, predicate, value + remove button)
    # => Note - 'condition' class required for interfacing with Ransack
    def condition_fields
      %w( fields condition).freeze
    end

    # Classes applied to the value input field in a single query condition
    # => Note - 'fields' class required for interfacing with Ransack
    def value_fields
      %w( fields value col-3).freeze
    end

    # Predicates available to use in each query condition
    def app_predicates
      %i( cont eq not_eq matches does_not_match lt lteq gt gteq not_cont start not_start end not_end )
    end

  end

end