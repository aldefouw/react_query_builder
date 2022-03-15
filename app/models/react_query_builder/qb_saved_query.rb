module ReactQueryBuilder

  class QbSavedQuery < ApplicationRecord

    before_save :set_last_run_date

    after_initialize :update_labels_based_upon_view

    def update_labels_based_upon_view
      qb_field_mapping.update(labels: updated_cols) if !columns_match && !query_type_unavailable
    end

    def query_type_unavailable
      self.query_type.nil?
    end

    def updated_cols
      cols = Hash.new{|hash, key| hash[key] = Hash.new{|hash, key| hash[key] = Array.new}}
      combined = (qb_labels.keys + missing_cols).flatten.compact
      combined.each { |e| cols[e] = e.titleize }
      cols
    end

    def columns_match
      query_cols.sort == label_keys.sort unless query_type_unavailable
    end

    def missing_cols
      query_cols.map{|c| c unless label_keys.include?(c) } unless query_type_unavailable
    end

    def query_cols
      current_query.column_names unless query_type_unavailable
    end

    def label_keys
      qb_labels.map { |b| b.first }
    end

    def qb_labels
      unless query_type_unavailable
        qb_field_mapping.labels.class == String ? JSON.parse(qb_field_mapping.labels) : qb_field_mapping.labels
      end
    end

    def formatted_labels
      qb_labels.map { |b| {accessor: b.first, Header: b.second} }
    end

    def qb_field_mapping
      existing_field_mapping.nil? ? create_initial_mapping : existing_field_mapping unless query_type_unavailable
    end

    def existing_field_mapping
      QbFieldMapping.find_by(model: query_type.camelize)
    end

    def create_initial_mapping
      QbFieldMapping.create(model: query_type.camelize, labels: {})
    end

    def set_last_run_date
      self.last_run = Date.today
    end

    def selected_cols
      cols = JSON.parse(self.display_fields)
      cols.respond_to?(:keys) ? cols.keys : cols
    end

    def display_row(row)
      t = {}
      self.selected_cols.each { |n| t[n] = format_cell(row, n) }
      t
    end

    def format_cell(row, n)
      t = row.send(n)
      t.class == ActiveSupport::TimeWithZone ? time_format(t) : t
    end

    def time_format(s)
      s.to_time.to_s
    end

    def react_table_cols
      self.selected_cols.map { |n| { Header: header_name(n), accessor: n, type: col_type(n) } }.to_json
    end

    def header_name(n)
      formatted_labels.map{|b| b[:Header] if b[:accessor] == n}.compact.first
    end

    def col_type(n)
      if current_query.respond_to?(:type_overrides) &&
        current_query.type_overrides.include?(n.to_sym)
        current_query.type_overrides[n.to_sym]
      else
        current_query.columns_hash[n].type
      end
    end

    def current_query
      "#{self.class.module_parent_name}::#{query_type.classify}".constantize unless query_type_unavailable
    end

    def set_last_run_time(user:)
      self.update(last_run: Date.today,
                  last_run_by: defined?(:user_method) && user ?
                                 user.send(QueryBuilderRecord.user_method) :
                                 "application")
    end

  end

end