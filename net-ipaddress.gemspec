# coding: us-ascii

require File.expand_path('../lib/net/ipaddress/version', __FILE__)

Gem::Specification.new do |gem|
  # specific

  gem.description   = %q{Utils for ipaddresses}
  gem.summary       = gem.description.dup
  gem.homepage      = 'https://github.com/kachick/net-ipaddress'
  gem.license       = 'MIT'
  gem.name          = 'net-ipaddress'
  gem.require_paths = ['lib']
  gem.version       = Net::IPAddress::VERSION.dup

  gem.add_development_dependency 'declare', '~> 0.0.6'
  gem.add_development_dependency 'yard', '>= 0.9.20', '< 2'
  gem.add_development_dependency 'rake', '>= 10', '< 20'
  gem.add_development_dependency 'bundler', '>= 2', '< 3'

  if RUBY_ENGINE == 'rbx'
    gem.add_dependency 'rubysl', '~> 2.1'
  end

  # common

  gem.authors       = ['Kenichi Kamiya']
  gem.email         = ['kachick1+ruby@gmail.com']
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
end
