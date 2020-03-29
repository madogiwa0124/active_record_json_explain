# frozen_string_literal: true

require_relative './sample/postgresql/model/sample'
require_relative './sample/mysql/model/sample'

# NOTE
# Depending on the timing, it may be overwritten by ActiveRecord
# after `require` is executed and the monkey patch may not work,
# so it is loaded.
load 'active_record_json_explain.rb'

RSpec.describe ActiveRecordJsonExplain do
  it 'has a version number' do
    expect(ActiveRecordJsonExplain::VERSION).not_to be nil
  end

  context 'mysql' do
    describe 'explain' do
      it 'default explain result', aggregate_failures: true do
        result = Mysql::Sample.with_title.explain
        expect(result).to match(/EXPLAIN for:/)
        expect(result).to match(/SELECT `samples`.* FROM `samples`/)
        expect(result).to match(/WHERE `samples`.`title` = 'hoge'/)
        [
          /id/, /select_type/, /table/, /partitions/, /type/,
          /possible_keys/, /key/, /key_len/, /ref/, /rows/, /filtered/, /Extra/
        ].each do |regexp|
          expect(result).to match regexp
        end
        expect(result).to match(/1 row in set/)
      end
    end

    describe 'explain(json: true)' do
      it 'json explain result', aggregate_failures: true do
        result = Mysql::Sample.with_title.explain(json: true)
        expect(result).to match(/EXPLAIN for:/)
        expect(result).to match(/SELECT `samples`.* FROM `samples`/)
        expect(result).to match(/WHERE `samples`.`title` = 'hoge'/)
        [
          /query_block/, /select_id/, /cost_info/, /table/, /table_name/,
          /rows_examined_per_scan/, /rows_produced_per_join/, /filtered/,
          /used_columns/, /attached_condition/
        ].each do |regexp|
          expect(result).to match regexp
        end
        expect(result).to match(/1 row in set/)
      end
    end
  end

  context 'postgresql' do
    describe 'explain' do
      it 'default explain result', aggregate_failures: true do
        result = Postgresql::Sample.with_title.explain
        expect(result).to match(/EXPLAIN for:/)
        expect(result).to match(/SELECT "samples".* FROM "samples"/)
        expect(result).to match(/WHERE "samples"."title" = \$1 \[\["title", "hoge"\]\]/)
        expect(result).to match(/Seq Scan on samples/)
        expect(result).to match(/Filter/)
        expect(result).to match(/rows/)
      end
    end

    describe 'explain(json: true)' do
      it 'json explain result', aggregate_failures: true do
        result = Postgresql::Sample.with_title.explain(json: true)
        expect(result).to match(/EXPLAIN for:/)
        expect(result).to match(/SELECT "samples".* FROM "samples"/)
        expect(result).to match(/WHERE "samples"."title" = \$1 \[\["title", "hoge"\]\]/)
        [
          /Plan/, /Node Type/, /Parallel Aware/, /Relation Name/, /Alias/,
          /Startup Cost/, /Total Cost/, /Plan Rows/, /Plan Width/, /Filter/
        ].each do |regexp|
          expect(result).to match regexp
        end
        expect(result).to match(/row/)
      end
    end
  end
end
