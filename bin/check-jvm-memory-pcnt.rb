#! /usr/bin/env ruby
require 'sensu-plugin/check/cli'
require 'jolokia'

#   check-jvm-heap-pcnt
#
# DESCRIPTION: Check the percentage of Java JVM HEAP Memory:
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
#    ./check-jvm-heap-pcnt.rb -w 90 -c 95'
#
# http://www.rubydoc.info/gems/jolokia/0.1.0
# *:type=Connector,*

class CheckJvmMemoryPcnt < Sensu::Plugin::Check::CLI
  option :url,
         description: 'URL of the Jolokia Agent to the constructor for creating the client',
         short: '-u URL',
         long: '--url URL',
         default: 'http://localhost:8080/jolokia'

  option :type,
         description: 'The type of memory [NonHeap/Heap] to query',
         short: '-t VALUE',
         long: '--type VALUE',
         in: %w(heap nonheap),
         required: true

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

    # Select the correct attribute to query based on the type option
    if config[:type] == 'heap'
      attr = 'HeapMemoryUsage'
    elsif config[:type] == 'nonheap'
      attr = 'NonHeapMemoryUsage'
    else
      unknown 'The type [-t/--type] option was not set use: < heap / nonheap >'
    end

    # Perform actions read or execute the operations of the MBeans
    begin
      jolokia_response = jolokia.request(
        :post,
        type: 'read',
        mbean: 'java.lang:type=Memory',
        attribute: attr.to_s
      )
    rescue StandardError => e
      puts ''
      unknown e.message
    end

    max = (jolokia_response['value']['max'])
    committed = (jolokia_response['value']['committed'])
    pct_committed = (committed.to_f / max.to_f * 100).to_i
    used = (jolokia_response['value']['used'])
    pct_used = (used.to_f / max.to_f * 100).to_i

    if pct_used > config[:crit].to_i
      critical "Java #{config[:type].upcase} Memory: Committed #{pct_committed}%, Used #{pct_used}%"
    elsif pct_used > config[:warn].to_i
      warning "Java #{config[:type].upcase} Memory: Committed #{pct_committed}%, Used #{pct_used}%"
    else
      ok "Java #{config[:type].upcase} Memory: Committed #{pct_committed}%, Used #{pct_used}%"
    end
  end
end
