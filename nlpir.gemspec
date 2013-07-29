# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nlpir/version'

Gem::Specification.new do |spec|
  spec.name          = "nlpir"
  spec.version       = Nlpir::VERSION
  spec.authors       = ["JoeWoo"]
  spec.email         = ["0wujian0@gmail.com"]
  spec.description   = %q{"A rubygem wrapper of chinese segment tools ICTCLAS2013"}
  spec.summary       = %q{"ICTCLAS是由中国科学院计算技术研究所研发。中文分词；词性标注；命名实体识别；新词识别；同时支持用户词典。"}
  spec.homepage      = "https://github.com/JoeWoo/nlpir"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.platform = Gem::Platform::CURRENT

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
