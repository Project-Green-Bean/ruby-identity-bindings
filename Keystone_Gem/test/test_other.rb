require File.join(File.dirname(__FILE__), '../lib/keystone.rb')
require 'test/unit'
require File.join(File.dirname(__FILE__), '../test/test_parameters.rb')

#testing catalog and token_get

class TestOther < Test::Unit::TestCase
	$aut = Keystone.new($admin,$adminPass,$serverURL,$serverPort1,$serverPort2)
	$fai = Keystone.new($admin,$randomPass,$serverURL,$serverPort1,$serverPort2)
	$aut.auth($tenant)
	$fai.auth($tenant)
	#token tests
	def test_token_get	
			expected = $aut.token_get
			assert_equal expected, true
	end

	def test_failure_auth_token_get	
			expected = $fai.token_get
			assert_equal expected, false
	end


	#catalog tests
	def test_catalog	
			expected = $aut.catalog
			assert_equal expected, true
	end

	def test_failure_auth_catalog
			expected = $fai.catalog
			assert_equal expected, false
	end

end

