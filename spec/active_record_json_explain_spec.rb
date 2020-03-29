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
      it 'default explain result' do
        result = File.read('spec/json_explain/mysql_default_explain.txt')
        expect(Mysql::Sample.with_title.explain).to eq result
      end
    end

    describe 'explain(json: true)' do
      it 'json explain result' do
        result = File.read('spec/json_explain/mysql_json_explain.txt')
        expect(Mysql::Sample.with_title.explain(json: true)).to eq result
      end
    end
  end

  context 'postgresql' do
    describe 'explain' do
      it 'default explain result' do
        result = File.read('spec/json_explain/postgresql_default_explain.txt')
        expect(Postgresql::Sample.with_title.explain).to eq result
      end
    end

    describe 'explain(json: true)' do
      it 'json explain result' do
        result = File.read('spec/json_explain/postgresql_json_explain.txt')
        expect(Postgresql::Sample.with_title.explain(json: true)).to eq result
      end
    end
  end
end
