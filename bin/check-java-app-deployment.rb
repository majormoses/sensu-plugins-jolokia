#! /usr/bin/env ruby
require 'sensu-plugin/check/cli'
require 'jolokia'

#   check-java-app-deployment
#
# DESCRIPTION: Check current runtime status/deploymnet status of a application:
#   A deployment represents anything that can be deployed:
#   Such as EJB-JAR, WAR, EAR, any kind of standard archive such as RAR or JBoss-specific deployment)
#
# OUTPUT:
#   plain text
#
#  Possible status modes are OK, FAILED, and STOPPED.
#    FAILED indicates a dependency is missing or a service could not start.
#    STOPPED indicates that the deployment was not enabled or was manually stopped."
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
#    ./check-java-app-deployment.rb -u http://localhost:8080/jolokia -a 'jolokia-war-agent.war'
#
# http://www.rubydoc.info/gems/jolokia/0.1.0
# *:type=Connector,*

class CheckJavaAppDeploymnet < Sensu::Plugin::Check::CLI
  option :url,
         description: 'URL of the Jolokia Agent to the constructor for creating the client',
         short: '-u URL',
         long: '--url URL',
         default: 'http://localhost:8080/jolokia'

  option :apps,
         description: 'A comma seperated list of application paths to verify are in a OK state',
         short: '-a VALUE',
         long: '--applications VALUE',
         required: true

  def run
    # Create an instance of Jolokia::Client to comunicate with the Jolokia Agent

    jolokia = Jolokia.new(url: config[:url])

    # Create array from apps option
    apps = config[:apps].split(',')

    # Empty array for app status
    apps_with_errors = []

    apps.each do |app|
      # Perform actions read or execute the operations of the MBeans
      begin
        jolokia_response = jolokia.request(
          :post,
          type: 'read',
          mbean: "jboss.as:deployment=#{app}",
          attribute: 'status'
        )
      rescue StandardError => e
        puts ''
        unknown e.message
      end

      unless jolokia_response['value'] == 'OK'
        apps_with_errors << app
      end
    end

    if apps_with_errors.any?
      critical "The appliations #{apps_with_errors} are NOT deployed"
    else
      ok "The applications #{apps} are deployed"
    end
  end
end
