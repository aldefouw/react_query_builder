module ReactQueryBuilder

  class QueryBuilder < QueryBuilderRecord

    after_initialize :default_boolean_cols

    self.abstract_class = true

    def self.labels
      field_mappings.labels if field_mappings
    end

    def self.field_mappings
      QbFieldMapping.find_by(model: self.name.demodulize)
    end

    def self.reports
      ::Rails.application.eager_load!

      self.descendants.map(&:name).
        map { |n| { title: n.constantize.title, model: n.demodulize } }.
        sort_by{ |h| h[:title] }
    end

    def self.report_included?(report_klass)
      reports.map { |n| n[:model] }.include?(report_klass.classify) unless report_klass.nil?
    end

    def self.load_enums_for(models:)
      models.each do |model|
        model.columns.map do |c|
          if c.type == :integer && model.respond_to?(c.name.pluralize) && c.name.pluralize != "ids"
            enum c.name.to_sym => model.send(c.name.pluralize.to_sym), _prefix: c.name.to_sym
          end
        end
      end
    end

    def default_boolean_cols
      self.class.columns.each do |col|
        if col.sql_type_metadata.type == :boolean
          define_singleton_method(col.name) do |*args|
            super(*args).nil? ? "" : super(*args) ? "Yes" : "No"
          end
        end
      end

      if self.respond_to?(:boolean_override)
        boolean_override.each do |k, v|
          define_singleton_method(k) do |*args|
            super(*args).nil? ? "" : super(*args) ? v[0] : v[1]
          end
        end
      end
    end

  end

end