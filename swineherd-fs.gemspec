# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{swineherd-fs}
  s.version = "0.0.2"
  s.authors = ["David Snyder","Jacob Perkins"]
  s.date = %q{2012-01-20}
  s.description = %q{A filesystem abstraction for Amazon S3 and Hadoop HDFS}
  s.summary = %q{A filesystem abstraction for Amazon S3 and Hadoop HDFS}
  s.email = %q{"david@infochimps.com"}
  s.homepage = %q{http://github.com/infochimps-labs/swineherd-fs}

  s.files = ["LICENSE", "VERSION","Gemfile", "swineherd-fs.gemspec", "rspec.watchr", "README.textile", "lib/swineherd-fs.rb","lib/swineherd-fs/localfilesystem.rb", "lib/swineherd-fs/s3filesystem.rb", "lib/swineherd-fs/hadoopfilesystem.rb", "spec/spec_helper.rb", "spec/filesystem_spec.rb"]
  s.test_files =  ["spec/spec_helper.rb", "spec/filesystem_spec.rb"]
  s.require_paths = ["lib"]

  s.add_development_dependency("rspec")
  s.add_development_dependency("watchr")
  s.add_runtime_dependency(%q<configliere>, [">= 0"])
  s.add_runtime_dependency(%q<right_aws>, [">= 0"])
end
