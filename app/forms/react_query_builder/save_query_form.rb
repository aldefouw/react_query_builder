module ReactQueryBuilder

  class SaveQueryForm < Reform::Form

    include Reform::Form::ActiveModel::ModelReflections

    property :title, validates: { presence: true }
    validates_uniqueness_of :title, scope: :query_type

    property :description

    property :display_fields
    property :q
    property :query_type

  end

end