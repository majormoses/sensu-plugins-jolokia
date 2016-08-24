require_relative '../bin/check-jvm-memory-pcnt.rb'
require_relative '../bin/check-java-app-deployment.rb'
require_relative '../bin/check-jolokia-key.rb'
require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start
