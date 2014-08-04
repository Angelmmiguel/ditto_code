require 'dittocode/parse'
require 'dittocode/exec'
require 'dittocode/talk'
include DittoCode::Exec
include DittoCode::Talk

module DittoCode
  def self.symbolize_keys h
    h.inject({}) { |opts,(k,v)| opts[(k.to_sym rescue k) || k] = v; opts }
  end
end