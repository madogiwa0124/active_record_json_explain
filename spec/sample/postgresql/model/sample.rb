# frozen_string_literal: true

require_relative '../postgresql.rb'

module Postgresql
  class Sample < ActiveRecord::Base
    establish_connection(
      adapter: Postgresql::ADAPTER,
      host: 'localhost',
      username: 'sample',
      password: 'password',
      database: 'sample'
    )

    require 'active_record_json_explain'

    scope :with_title, -> { where(title: 'hoge') }
  end
end
