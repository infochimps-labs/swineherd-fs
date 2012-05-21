require 'configliere' ; Configliere.use(:commandline, :env_var, :define,:config_file)
require 'logger'

require 'fileutils'
require 'tempfile'

require 'swineherd-fs/filesystem'
require 'swineherd-fs/localfilesystem'
require 'swineherd-fs/s3filesystem'
require 'swineherd-fs/hadoopfilesystem'

module Swineherd

  # Merge in system and user settings
  SYSTEM_CONFIG_PATH = "/etc/swineherd.yaml" unless defined?(SYSTEM_CONFIG_PATH)
  USER_CONFIG_PATH = File.join(ENV['HOME'], '.swineherd.yaml') unless
    defined?(USER_CONFIG_PATH)

  def self.configure_hadoop_jruby
    hadoop_home = ENV['HADOOP_HOME']

    raise "\nHadoop installation not found. Try setting $HADOOP_HOME\n" unless
      (hadoop_home and (File.exist? hadoop_home))

    $CLASSPATH << File.join(File.join(hadoop_home, 'conf') ||
                            ENV['HADOOP_CONF_DIR'],
                            '') # add trailing slash
                            
    Dir["#{hadoop_home}/{hadoop*.jar,lib/*.jar}"].each{|jar| require jar}

    begin
      require 'java'
    rescue LoadError => e
      raise "\nJava not found. Are you sure you're running with JRuby?\n" +
        e.message
    end
  end

  def self.get_hadoop_conf
    conf = Java::org.apache.hadoop.conf.Configuration.new

    # per-site defaults
    %w[capacity-scheduler.xml core-site.xml hadoop-policy.xml
       hadoop-site.xml hdfs-site.xml mapred-site.xml].each do |conf_file|
      conf.addResource conf_file
    end
    conf.reload_configuration

    # per-user overrides
    if Swineherd.config[:aws]
      conf.set("fs.s3.awsAccessKeyId",Swineherd.config[:aws][:access_key])
      conf.set("fs.s3.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])

      conf.set("fs.s3n.awsAccessKeyId",Swineherd.config[:aws][:access_key])
      conf.set("fs.s3n.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])
    end

    conf
  end

  def self.config
    return @config if @config
    config = Configliere::Param.new
    config.read SYSTEM_CONFIG_PATH if File.exists? SYSTEM_CONFIG_PATH
    config.read USER_CONFIG_PATH  if File.exists? USER_CONFIG_PATH
    @config ||= config
  end

  def self.logger
    return @log if @log
    @log ||= Logger.new(config[:log_file] || STDOUT)
    @log.formatter = proc { |severity, datetime, progname, msg|
      "[#{severity.upcase}] #{msg}\n"
    }
    @log
  end

  def self.logger= logger
    @log = logger
  end
end
