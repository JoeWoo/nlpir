require 'rubygems'
require 'rake'
require 'rake/testtask'
require File.expand_path('../../lib/nlpir.rb', __FILE__)


class NlpirTest < Test::Unit::TestCase
  def test_init
    assert_equal 1,
       NLPIR_Init(nil, UTF8_CODE )
  end
end