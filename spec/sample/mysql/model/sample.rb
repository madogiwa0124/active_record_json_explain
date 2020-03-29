# frozen_string_literal: true

require_relative '../mysql.rb'

module Mysql
  class Sample < ActiveRecord::Base
    establish_connection(
      adapter: Mysql::ADAPTER,
      host: 'localhost',
      username: 'root',
      password: nil,
      database: 'sample'
    )

    scope :with_title, -> { where(title: 'hoge') }
  end
end
