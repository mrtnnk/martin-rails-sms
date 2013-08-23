gem	'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require_relative File.join('..', 'lib', 'sms-easy.rb')
SMSEasy::Client.config_yaml