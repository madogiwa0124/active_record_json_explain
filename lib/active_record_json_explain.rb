# frozen_string_literal: true

require 'active_record_json_explain/version'

module ActiveRecordJsonExplain
  class Error < StandardError; end
  # Your code goes here...
end

# rubocop:disable all
# Usage
# ``` ruby
# # NOTE:
# # if use postgresql adapter, Rails run `require 'activerecord/lib/active_record/connection_adapters/postgresql/database_statement'` when establish_connection runs.
# # So run `require 'active_record_scope_analyzer/json_explain'` after `establish_connection`.
# require 'active_record_scope_analyzer/json_explain'
# class Sample < ActiveRecord::Base
#   scope :with_title, -> { where(title: 'hoge') }
# end
#
# --- MySql ---
# Sample.with_title.explain
# => EXPLAIN for: SELECT `samples`.* FROM `samples` WHERE `samples`.`title` = 'hoge'
# +----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-------------+
# | id | select_type | table   | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
# +----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-------------+
# |  1 | SIMPLE      | samples | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    1 |    100.0 | Using where |
# +----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-------------+
# 1 row in set (0.00 sec)
#
# Sample.with_title.explain(json: true)
# => EXPLAIN for: SELECT `samples`.* FROM `samples` WHERE `samples`.`title` = 'hoge'
# +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
# | EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
# +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
# | {
#   "query_block": {
#     "select_id": 1,
#     "cost_info": {
#       "query_cost": "0.35"
#     },
#     "table": {
#       "table_name": "samples",
#       "access_type": "ALL",
#       "rows_examined_per_scan": 1,
#       "rows_produced_per_join": 1,
#       "filtered": "100.00",
#       "cost_info": {
#         "read_cost": "0.25",
#         "eval_cost": "0.10",
#         "prefix_cost": "0.35",
#         "data_read_per_join": "1K"
#       },
#       "used_columns": [
#         "id",
#         "category",
#         "title",
#         "body"
#       ],
#       "attached_condition": "(`sample`.`samples`.`title` = 'hoge')"
#     }
#   }
# } |
# +------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
# 1 row in set (0.00 sec)
#
# --- Postgresql ---
# Sample.with_title.explain
# => EXPLAIN for: SELECT "samples".* FROM "samples" WHERE "samples"."title" = $1 [["title", "hoge"]]
#                         QUERY PLAN
# ----------------------------------------------------------
#  Seq Scan on samples  (cost=0.00..11.62 rows=1 width=556)
#    Filter: ((title)::text = 'hoge'::text)
# (2 rows)
#
# Sample.with_title.explain(json: true)
# => EXPLAIN for: SELECT "samples".* FROM "samples" WHERE "samples"."title" = $1 [["title", "hoge"]]
#                                                                                                                                                     QUERY PLAN
# ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#  [
#   {
#     "Plan": {
#       "Node Type": "Seq Scan",
#       "Parallel Aware": false,
#       "Relation Name": "samples",
#       "Alias": "samples",
#       "Startup Cost": 0.00,
#       "Total Cost": 11.62,
#       "Plan Rows": 1,
#       "Plan Width": 556,
#       "Filter": "((title)::text = 'hoge'::text)"
#     }
#   }
# ]
# (1 row)
# ```
# rubocop:enable all

# NOTE
# Depending on the timing, it may be overwritten by ActiveRecord after `require` is executed and the monkey patch may not work,
# so it is loaded.
load 'active_record_json_explain/activerecord/monkey_patches/json_explain.rb'
