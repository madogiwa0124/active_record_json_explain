# frozen_string_literal: true

require_relative '../postgresql.rb'

module Postgresql
  class Sample < ActiveRecord::Base
    establish_connection(
      adapter: Postgresql::ADAPTER,
      host: '0.0.0.0',
      username: 'sample',
      password: 'password',
      database: 'sample'
    )

    scope :with_title, -> { where(title: 'hoge') }
  end
end
