lib_dir = File.join(File.dirname(__FILE__), '../lib')
full_lib_dir = File.expand_path(lib_dir)
$LOAD_PATH.unshift(full_lib_dir) unless
	$LOAD_PATH.include?(lib_dir) || $LOAD_PATH.include?(full_lib_dir)

Dir["./spec/support/**/*.rb"].each { |f| require f }

include Ruplicity

