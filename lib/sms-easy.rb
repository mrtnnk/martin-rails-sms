require 'action_mailer'
require 'yaml'

require_relative 'sms/easy/easy'
require_relative 'sms/easy/easy_helper'
require_relative 'sms/easy/notifier'
require_relative 'sms/easy/exception'

SMSEasy::Client.configure
