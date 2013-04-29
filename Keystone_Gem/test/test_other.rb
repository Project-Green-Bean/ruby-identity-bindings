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
			a = $aut.token_get
			expected = a[0]
			assert_equal expected, true
	end

	def test_failure_auth_token_get	
			a = $fai.token_get
			expected = a[0]
			assert_equal expected, false
	end

	#catalog tests
	def test_catalog	
			a = $aut.catalog
			expected = a[0]
			assert_equal expected, true
	end

	def test_failure_auth_catalog
			a = $fai.catalog
			expected = a[0]
			assert_equal expected, false
	end

end

