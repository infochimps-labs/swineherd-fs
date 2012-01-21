# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{swineherd-fs}
  s.version = "0.0.1"
  s.authors = ["David Snyder","Jacob Perkins"]
  s.date = %q{2012-01-20}
  s.description = %q{A Unix-like filesystem abstraction for Amazon S3 and Hadoop HDFS.}
  s.email = %q{"david@infochimps.com"}
  s.homepage = %q{http://github.com/infochimps-labs/swineherd-fs}
  s.require_paths = ["lib"]

  s.add_development_dependency("rspec")
  s.add_development_dependency("watchr")
  s.add_runtime_dependency(%q<configliere>, [">= 0"])
  s.add_runtime_dependency(%q<right_aws>, [">= 0"])
  s.add_runtime_dependency(%q<jruby-openssl>, [">= 0"])
end
