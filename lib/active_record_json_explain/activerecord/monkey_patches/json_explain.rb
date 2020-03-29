# frozen_string_literal: true

require 'active_support'
require 'active_record'

# NOTE:
# This monkey patch add argument(json) for ActiveRecord::Relation#explain.
# Argument json is default false. Therefore, it does not affect the default behavior.
# Only MySql and Postgresql are supported.

# rubocop:disable all
module ActiveRecord
  class Relation
    # NOTE: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/relation.rb#L239-L241
    def explain(json: false) # NOTE: add arg json
      exec_explain(collecting_queries_for_explain { exec_queries }, json: json) # NOTE: add arg json
    end
  end

  module Explain
    # NOTE: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/explain.rb#L19-L36
    def exec_explain(queries, json: false) # NOTE: add arg json
      str = queries.map do |sql, binds|
        msg = +"EXPLAIN for: #{sql}"
        unless binds.empty?
          msg << " "
          msg << binds.map { |attr| render_bind(attr) }.inspect
        end
        msg << "\n"
        msg << connection.explain(sql, binds, json: json) # NOTE: add arg json
      end.join("\n")

      # Overriding inspect to be more human readable, especially in the console.
      def str.inspect
        self
      end

      str
    end
  end

  module ConnectionAdapters
    module PostgreSQL
      module DatabaseStatements
        # https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/mysql/database_statements.rb#L31-L38
        def explain(arel, binds = [], json: false) # NOTE: add arg json
          format_option = "(FORMAT JSON)" if json # NOTE: get format option
          sql = "EXPLAIN #{format_option} #{to_sql(arel, binds)}" # NOTE: set format option
          PostgreSQL::ExplainPrettyPrinter.new.pp(exec_query(sql, "EXPLAIN", binds))
        end
      end
    end

    module MySQL
      module DatabaseStatements
        # NOTE: https://github.com/rails/rails/blob/master/activerecord/lib/active_record/connection_adapters/postgresql/database_statements.rb#L7-L10
        def explain(arel, binds = [], json: false) # NOTE: add arg json
          format_option = "FORMAT=JSON" if json # NOTE: get format option
          sql     = "EXPLAIN #{format_option} #{to_sql(arel, binds)}" # NOTE: set format option
          start   = Concurrent.monotonic_time
          result  = exec_query(sql, "EXPLAIN", binds)
          elapsed = Concurrent.monotonic_time - start

          MySQL::ExplainPrettyPrinter.new.pp(result, elapsed)
        end
      end
    end
  end
end

# rubocop:enable all
