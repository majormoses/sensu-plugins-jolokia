#! /usr/bin/env ruby
require 'sensu-plugin/check/cli'
require 'jolokia'

#   check-jvm-thread-count-pcnt
#
# DESCRIPTION: Check the percentage of Java JVM User Thread Count:
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: jolokia
#
# USAGE:
#  Specify Usage (Options):
#    ./check-jvm-thread-count-pcnt.rb -w 90 -c 95'
#
# http://www.rubydoc.info/gems/jolokia/0.1.0
# *:type=Connector,*

class CheckJvmThreadCountPcnt < Sensu::Plugin::Check::CLI
  option :url,
         description: 'URL of the Jolokia Agent to the constructor for creating the client',
         short: '-u URL',
         long: '--url URL',
         default: 'http://localhost:8080/jolokia'

  option :warn,
         description: 'The warning value when comparing against commited percent used',
         short: '-w VALUE',
         long: '--warning VALUE',
         required: true

  option :crit,
         description: 'The critical value when comparing against commited percent used',
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
        type: 'read',
        mbean: 'java.lang:type=Threading',
        attribute: 'ThreadCount'
      )
    rescue StandardError => e
      puts ''
      unknown e.message
    end

    max = `/bin/sh -c 'ulimit -u'`.to_i
    used = (jolokia_response['value'])
    pct_used = (used.to_f / max.to_f * 100).to_i

    if pct_used > config[:crit].to_i
      critical "Java User Thread Count Percentage: Used #{pct_used}%"
    elsif pct_used > config[:warn].to_i
      warning "Java User Thread Count Percentage: Used #{pct_used}%"
    else
      ok "Java User Thread Count Percentage: Used #{pct_used}%"
    end
  end
end
