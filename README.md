# ActiveRecordJsonExplain
[![Build Status](https://travis-ci.com/Madogiwa0124/active_record_json_explain.svg?branch=master)](https://travis-ci.com/Madogiwa0124/active_record_json_explain)

This gem extends `ActiveRecord::Relation#explain` to make it possible to get EXPLAIN in JSON format.(Only supported MySQL and Postgresql)

Supports ActiveRecord 5 latest and 6 latest.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_record_json_explain', require: false
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install active_record_json_explain

## Usage

If you use this gem, you can get the result in JSON format by `explain(json: true)`.

``` ruby
# NOTE:
# if use postgresql adapter, Rails run `require 'activerecord/lib/active_record/connection_adapters/postgresql/database_statement'` when establish_connection runs.
# So run `require 'active_record_json_explain'` after `establish_connection`.
require 'active_record_json_explain'

class Sample < ActiveRecord::Base
  scope :with_title, -> { where(title: 'hoge') }
end

# --- MySql ---
Sample.with_title.explain
=> EXPLAIN for: SELECT `samples`.* FROM `samples` WHERE `samples`.`title` = 'hoge'
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-------------+
| id | select_type | table   | partitions | type | possible_keys | key  | key_len | ref  | rows | filtered | Extra       |
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-------------+
|  1 | SIMPLE      | samples | NULL       | ALL  | NULL          | NULL | NULL    | NULL |    1 |    100.0 | Using where |
+----+-------------+---------+------------+------+---------------+------+---------+------+------+----------+-------------+
1 row in set (0.00 sec)

Sample.with_title.explain(json: true)
=> EXPLAIN for: SELECT `samples`.* FROM `samples` WHERE `samples`.`title` = 'hoge'
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| EXPLAIN                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| {
  "query_block": {
    "select_id": 1,
    "cost_info": {
      "query_cost": "0.35"
    },
    "table": {
      "table_name": "samples",
      "access_type": "ALL",
      "rows_examined_per_scan": 1,
      "rows_produced_per_join": 1,
      "filtered": "100.00",
      "cost_info": {
        "read_cost": "0.25",
        "eval_cost": "0.10",
        "prefix_cost": "0.35",
        "data_read_per_join": "1K"
      },
      "used_columns": [
        "id",
        "category",
        "title",
        "body"
      ],
      "attached_condition": "(`sample`.`samples`.`title` = 'hoge')"
    }
  }
} |
+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
1 row in set (0.00 sec)

#--- Postgresql ---
Sample.with_title.explain
=> EXPLAIN for: SELECT "samples".* FROM "samples" WHERE "samples"."title" = $1 [["title", "hoge"]]
                        QUERY PLAN
----------------------------------------------------------
Seq Scan on samples  (cost=0.00..11.62 rows=1 width=556)
  Filter: ((title)::text = 'hoge'::text)
(2 rows)

Sample.with_title.explain(json: true)
=> EXPLAIN for: SELECT "samples".* FROM "samples" WHERE "samples"."title" = $1 [["title", "hoge"]]
                                                                                                                                                    QUERY PLAN
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
[
  {
    "Plan": {
      "Node Type": "Seq Scan",
      "Parallel Aware": false,
      "Relation Name": "samples",
      "Alias": "samples",
      "Startup Cost": 0.00,
      "Total Cost": 11.62,
      "Plan Rows": 1,
      "Plan Width": 556,
      "Filter": "((title)::text = 'hoge'::text)"
    }
  }
]
(1 row)
```

## Development

Use docker-compose to build mysql and postgres containers for development.

```
$ docker-compose up -d
Creating active_record_json_explain_mysql_1    ... done
Creating active_record_json_explain_postgres_1 ... done

$ docker-compose ps
                Name                               Command              State                 Ports
-----------------------------------------------------------------------------------------------------------------
active_record_json_explain_mysql_1      docker-entrypoint.sh mysqld     Up      0.0.0.0:3306->3306/tcp, 33060/tcp
active_record_json_explain_postgres_1   docker-entrypoint.sh postgres   Up      0.0.0.0:5432->5432/tcp
```

run `bin/db_setup` and create sample database and table for MySQL, Postgresql.

```
$ bin/db_setup
=== START DB SETUP ====
= MySQL START =
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| root               |
| sample             |
| sys                |
+--------------------+
+------------------+
| Tables_in_sample |
+------------------+
| samples          |
+------------------+
= MySQL END =
= Postgresql START =
CREATE TABLE
         List of relations
 Schema |  Name   | Type  | Owner
--------+---------+-------+--------
 public | samples | table | sample
(1 row)

= Postgresql END =
=== END DB SETUP ====
```

Run require sample model and gem code.

``` ruby
irb(main):001:0> require_relative './spec/sample/mysql/model/sample'
=> true
irb(main):002:0> require 'active_record_json_explain'
=> true
irb(main):003:0> Mysql::Sample.with_title.explain(json: true)
=> EXPLAIN for: SELECT `samples`.* FROM `samples` WHERE `samples`.`title` = 'hoge'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Madogiwa0124/active_record_json_explain. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/Madogiwa0124/active_record_json_explain/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ActiveRecordJsonExplain project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/Madogiwa0124/active_record_json_explain/blob/master/CODE_OF_CONDUCT.md).
