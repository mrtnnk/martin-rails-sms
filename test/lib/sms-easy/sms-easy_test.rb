require_relative File.join('..', '..', 'test_helper')

describe SMSEasy do

  before do
    @client = SMSEasy::Client.new
  end

  it 'should validate phone number' do
    assert_raises(SMSEasyException) { @client.deliver("456789011","AT&T","Message") }
    assert_equal("5555555555@txt.att.net", SMSEasy::Client.sms_address("1-555-555-5555","AT&T"))
  end

  it 'should properly format international numbers' do
    assert_equal("+445555555555@txt.att.net", SMSEasy::Client.sms_address("+44-555-555-5555","AT&T"))
  end
  
  it 'should not deliver blank messages' do
    assert_raises(SMSEasyException) { @client.deliver("1234567890","AT&T","") }
  end

  it 'should get addresses properly' do
    assert_equal("1234567890@txt.att.net", SMSEasy::Client.sms_address("1234567890","AT&T"))
  end

end
