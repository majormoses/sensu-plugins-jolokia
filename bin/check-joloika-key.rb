#! /usr/bin/env ruby
require 'sensu-plugin/check/cli'
require 'jolokia'

# http://www.rubydoc.info/gems/jolokia/0.1.0
# *:type=Connector,*

class CheckJolokiaKey < Sensu::Plugin::Check::CLI
  option :url,
    description: 'URL of the Jolokia Agent to the constructor for creating the client',
    short: '-u URL',
    long: '--url URL',
    default: 'http://localhost:8080/jolokia'

  option :type,
    description: 'Call type?',
    short: '-t TYPE',
    long: '--type TYPE',
    default: 'read'

  option :mbean,
    description: 'MBean to execute operations against',
    short: '-m MBEAN',
    long: '--mbean MBEAN',
    required: true

  option :attribute,
    description: 'MBean attribute name',
    short: '-a ATTRIBUTE',
    long: '--attribute ATTRIBUTE',
    required: true

  option :inner_key,
    description: 'The inner "key" returned from a value',
    short: '-i INNER_KEY',
    long: '--inner_key INNER_KEY'

  option :warn,
    description: 'The warning value when comparing against a key',
    short: '-w VALUE',
    long: '--warning VALUE',
    required: true

  option :crit,
    description: 'The critical value when comparigin against a key',
    short: '-c VALUE',
    long: '--critical VALUE',
    required: true

  def run
    # Create an instance of Jolokia::Client to comunicate with the Jolokia Agent
    jolokia = Jolokia.new(url: config[:url])

    # Perform actions read or execute the operations of the MBeans
    begin
      jolokia_response = jolokia.request(
        :post,
        type: config[:type],
        mbean: config[:mbean],
        attribute: config[:attribute],
        path: config[:inner_key]
      )
    rescue Exception => e
      puts ''
      unknown e.message
    end

    if jolokia_response['value'].to_i > config[:crit].to_i
      critical "#{config[:attribute]} #{config[:inner_key]} : #{jolokia_response['value']}"
    elsif jolokia_response['value'].to_i > config[:warn].to_i
      warning "#{config[:attribute]} #{config[:inner_key]} : #{jolokia_response['value']}"
    end

  end

end
