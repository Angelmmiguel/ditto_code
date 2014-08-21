require 'pry'
include DittoCode::Exec

Dir["spec/code/*.rb"].each {|file| require "./#{file}" }

include Code
