require 'metamorfose/version'

require 'kiba'
require 'kiba-common/sources/enumerable'

require 'metamorfose/input/csv'
require 'metamorfose/output/csv'

module Metamorfose
  def self.root_path
    File.expand_path('../..', __FILE__)
  end
end
