require 'test/unit'
require 'sms_fu'
require 'sms_notifier'
require 'action_mailer'

class SmsFuTest < Test::Unit::TestCase
  include SMSFu
  
  def test_validity_of_number
    assert_raise(SMSFuException) { deliver_sms("123456789011","AT&T","Message") }
    assert_equal("5555555555@txt.att.net", get_sms_address("1-555-555-5555","AT&T"))
  end

  def test_handling_of_blank_message
    assert_raise(SMSFuException) { deliver_sms("1234567890","AT&T","") }
  end

  def test_get_sms_address
    assert_equal("1234567890@txt.att.net", get_sms_address("1234567890","AT&T"))
  end
end
