# frozen_string_literal: true

require 'rspec'
require 'active_record'
require 'active_record/version'
require 'active_support'
require 'active_support/core_ext'
require 'ostruct'
require 'pathname'
require 'activerecord-import'
require 'yaml'

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'paperclip')
require File.join(ROOT, 'lib', 'paperclip.rb')

FIXTURES_DIR = File.join(File.dirname(__FILE__), "fixtures")
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")

`mysql -h 127.0.0.1 -u root -e "DROP DATABASE IF EXISTS paperclip_test; \
  CREATE DATABASE IF NOT EXISTS paperclip_test;"`

ActiveRecord::Base.establish_connection(config['test'])

Paperclip.options[:logger] = ActiveRecord::Base.logger

Dir[File.join(ROOT, 'spec', 'support', '**', '*.rb')].each{ |f| require f }

Rails = FakeRails.new('test', Pathname.new(ROOT).join('tmp'))
ActiveSupport::Deprecation.silenced = true

RSpec.configure do |config|
  config.include Assertions
  config.include ModelReconstruction
  config.include TestData
  config.include Reporting
  config.extend VersionHelper

  config.before(:all) do
    rebuild_model
  end
end
