require 'rubygems'
require 'active_record'
require 'active_record/base'

require File.dirname(__FILE__) + '/../init.rb'
require File.dirname(__FILE__) + '/models/band'
require File.dirname(__FILE__) + '/models/user'

require 'test/unit'
require 'shoulda'
require 'factory_girl'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'sqlite3')

load(File.dirname(__FILE__) + '/schema.rb')
