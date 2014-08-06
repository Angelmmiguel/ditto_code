require 'dittocode/parse'
require 'dittocode/exec'
require 'dittocode/talk'
require 'dittocode/remove_file'
require 'dittocode/hold_file'
require 'dittocode/environments'
include DittoCode::Environments
include DittoCode::Exec
include DittoCode::Talk
include DittoCode::RemoveFile
include DittoCode::HoldFile

module DittoCode
  def self.symbolize_keys h
    h.inject({}) { |opts,(k,v)| opts[(k.to_sym rescue k) || k] = v; opts }
  end
end