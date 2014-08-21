require 'pry'
require 'ditto_code'

Dir["spec/code/*.rb"].each {|file| require "./#{file}" }

include Code
