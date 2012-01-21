require 'rubygems'
require 'configliere' ; Configliere.use(:commandline, :env_var, :define,:config_file)
require 'logger'

require 'fileutils'
require 'tempfile'
require 'right_aws'

require 'swineherd-fs/localfilesystem'
require 'swineherd-fs/hadoopfilesystem'
require 'swineherd-fs/s3filesystem'

#Merge in system and user settings
SYSTEM_CONFIG_PATH = "/etc/swineherd.yaml" unless defined?(SYSTEM_CONFIG_PATH)
USER_CONFIG_PATH   = File.join(ENV['HOME'], '.swineherd.yaml') unless defined?(USER_CONFIG_PATH)

module Swineherd

  def self.config
    return @config if @config
    config = Configliere::Param.new
    config.read SYSTEM_CONFIG_PATH if File.exists? SYSTEM_CONFIG_PATH
    config.read USER_CONFIG_PATH  if File.exists? USER_CONFIG_PATH
    @config ||= config
  end

  module FileSystem

    HDFS_SCHEME_REGEXP = /^hdfs:\/\//
    S3_SCHEME_REGEXP   = /^s3n?:\/\//

    FILESYSTEMS = {
      'file' => Swineherd::LocalFileSystem,
      'hdfs' => Swineherd::HadoopFileSystem,
      's3'   => Swineherd::S3FileSystem,
      's3n'  => Swineherd::S3FileSystem
    }

    # A factory function that returns an instance of the requested class
    def self.get scheme, *args
      begin
        FILESYSTEMS[scheme.to_s].new *args
      rescue NoMethodError => e
        raise "Filesystem with scheme #{scheme} does not exist.\n #{e.message}"
      end
    end

    def self.exists?(path)
      fs = self.get(scheme_for(path))
      Logger.new(STDOUT).info "Using #{fs.class}"
      fs.exists?(path)
    end

    def self.cp(srcpath,destpath)
      src_fs  = scheme_for(srcpath)
      dest_fs = scheme_for(destpath)
      Logger.new(STDOUT).info "#{src_fs} --> #{dest_fs}"
      if(src_fs.eql?(dest_fs))
        self.get(src_fs).cp(srcpath,destpath)
      elsif src_fs.eql?(:file)
        self.get(dest_fs).copy_from_local(srcpath,destpath)
      elsif dest_fs.eql?(:file)
        self.get(src_fs).copy_to_local(srcpath,destpath)
      else #cp between s3/s3n and hdfs can be handled by Hadoop:FileUtil in HadoopFileSystem
        self.get(:hdfs).cp(srcpath,destpath)
      end
    end

    private

    #defaults to local filesystem :file
    def self.scheme_for(path)
      scheme = URI.parse(path).scheme
      (scheme && scheme.to_sym) || :file
    end

  end

end
