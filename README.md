## sensu-plugins-jolokia

[![Build Status](https://travis-ci.org/smbambling/sensu-plugins-jolokia.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-jolokia)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-jolokia.svg)](http://badge.fury.io/rb/sensu-plugins-jolokia)
[![Code Climate](https://codeclimate.com/github/smbambling/sensu-plugins-jolokia/badges/gpa.svg)](https://codeclimate.com/github/smbambling/sensu-plugins-jolokia)
[![Test Coverage](https://codeclimate.com/github/smbambling/sensu-plugins-jolokia/badges/coverage.svg)](https://codeclimate.com/github/smbambling/sensu-plugins-jolokia)
[![Dependency Status](https://gemnasium.com/smbambling/sensu-plugins-jolokia.svg)](https://gemnasium.com/smbambling/sensu-plugins-jolokia)

## Functionality

**check-java-app-deployment**

Check current runtime status/deploymnet status of a application:
  A deployment represents anything that can be deployed:
  Such as EJB-JAR, WAR, EAR, any kind of standard archive such as RAR or JBoss-specific deployment)

**check-jvm-heap-pcnt**

Check the percentage of JVM HEAP Memory

**check-jvm-non-heap-pcnt**

Check the perentage of JVM Non-HEAP Memory

**check-joloki-key**

Check against a sepcified jolokia key and alert on a critical/warning threshold

## Files
 * check-java-app-deployment.rb
 * check-jvm-heap-pcnt.rb
 * check-non-jvm-heap-pcnt.rb
 * check-jolokia-key.rb

## Usage

## Installation

[Installation and Setup](http://sensu-plugins.io/docs/installation_instructions.html)