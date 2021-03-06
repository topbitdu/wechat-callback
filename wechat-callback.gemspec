# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wechat/callback/version'

Gem::Specification.new do |spec|
  spec.name        = 'wechat-callback'
  spec.version     = Wechat::Callback::VERSION
  spec.authors     = [ 'Topbit Du' ]
  spec.email       = [ 'topbit.du@gmail.com' ]
  spec.summary     = 'Wechat Callback Library 微信回调库'
  spec.description = 'Wechat Callback Library is a code base to handle the remote calls from the Wechat servers. 微信回调库用于处理微信服务器发出的请求。'
  spec.homepage    = 'https://github.com/topbitdu/wechat-callback'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = [ 'lib' ]

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake',    '~> 11.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'

end
