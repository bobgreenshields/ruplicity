$LOAD_PATH.unshift File.join(File.dirname(FILE), '..', 'lib')
#require 'ruplicity'
#require 'testlogger'

Dir["./spec/support/**/*.rb"].each { |f| require f }
