module OrderQuery
  class OrderCondition
    attr_reader :name, :order, :order_order, :options, :scope

    def initialize(scope, line)
      line              = line.dup
      @options          = line.extract_options!
      @name             = line[0]
      @order            = line[1] || :asc
      @order_order      = line[2] || :desc
      @scope            = scope
      @unique           = @options.key?(:unique) ? !!@options[:unique] : (name.to_s == scope.primary_key)
    end

    def unique?
      @unique
    end

    def col_name_sql
      sql = options[:sql]
      if sql
        sql = sql.call if sql.respond_to?(:call)
        sql
      else
        scope.connection.quote_table_name(scope.table_name) + '.' + scope.connection.quote_column_name(name)
      end
    end
  end
end
