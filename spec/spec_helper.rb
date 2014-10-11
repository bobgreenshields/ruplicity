$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib')
#require 'ruplicity'
#require 'testlogger'

Dir["./spec/support/**/*.rb"].each { |f| require f }
