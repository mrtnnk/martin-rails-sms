module SMSEasy
  class Client

    # Delivers the SMS message in the form of an e-mail
    #   sms-easy.deliver("1234567890","at&t","hello world")
    def deliver(number, carrier, message, options = {})
      raise SMSEasyException.new("Can't deliver blank message to #{format_number(number)}") if message.nil? || message.empty?

      limit   = options[:limit] || message.length
      from    = options[:from] || SMSEasy.from_address
      message = message[0..limit-1]
      email   = SMSEasy.sms_address(number,carrier)

      if @delivery == :pony
        Pony.mail({:to => email, :body => message, :from => from}.merge!(@pony_config))
      else
        SMSEasyNotifier.send_sms(email, message, from).deliver
      end
    end
  end
  
  class << self
    def config_yaml
      @@config_yaml ||= YAML::load(File.open("#{template_directory}/sms-easy.yml"))
    end
  
    # Returns back a list of all carriers
    #   SMSEasy.carriers
    def carriers
      config_yaml['carriers'] 
    end
  
    def from_address
      config_yaml['config']['from_address']
    end

    def carrier_name(key)
      carrier(key)['name']
    end
  
    def carrier_email(key)
      carrier(key.downcase)['value']
    end
    
    def carrier(key)
      raise SMSEasyException.new("Carrier (#{key}) is not supported") unless SMSEasy.carriers.has_key?(key.downcase)
      carriers[key]
    end

    # Returns back a properly formatted SMS e-mail address
    #   SMSEasy.sms_address("1234567890","at&t")
    def sms_address(number,carrier)
      raise SMSEasyException.new("Missing number or carrier") if number.nil? || carrier.nil?
      format_number(number) + carrier_email(carrier.downcase)
    end

    protected

    def format_number(number)
      stripped = number.gsub("-","").strip
      formatted = (stripped.length == 11 && stripped[0,1] == "1") ? stripped[1..stripped.length] : stripped
      raise SMSEasyException.new("Number (#{number}) is not formatted correctly") unless valid_number?(formatted)
      formatted
    end

    def valid_number?(number)
      number.length >= 10 && number[/^.\d+$/]
    end  

    def template_directory
      directory = defined?(Rails) ? "#{Rails.root}/config" : "#{File.dirname(__FILE__)}/../../templates"
      if (defined?(Rails) && Rails.env == 'test') || (defined?(RAILS_ENV) && RAILS_ENV == 'test)')
        "#{File.dirname(__FILE__)}/../../templates"
      else
        directory
      end
    end
  end
end

class SMSEasyException < StandardError; end