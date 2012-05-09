require 'java'
require 'open-uri'

module Swineherd
  class FileSystem
    #
    # If no path is provided, a filesystem will be generated using the
    # default hadoop configuration.
    #
    def initialize fs = :hdfs

      type = case fs
             when String then /([^:]*):\/\//.match(fs)[1].to_sym
             when Symbol then fs
             end

      @hadoop_home = ENV['HADOOP_HOME']

      hadoop_conf = (ENV['HADOOP_CONF_DIR'] || File.join(@hadoop_home, 'conf'))
      hadoop_conf += "/" unless hadoop_conf.end_with? "/"
      $CLASSPATH << hadoop_conf unless $CLASSPATH.include?(hadoop_conf)
      
      Dir["#{@hadoop_home}/{hadoop*.jar,lib/*.jar}"].each{|jar| require jar}
      
      @conf = Java::org.apache.hadoop.conf.Configuration.new

      if Swineherd.config[:aws]
        @conf.set("fs.s3.awsAccessKeyId",Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])

        @conf.set("fs.s3n.awsAccessKeyId",Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3n.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])
      end

      @type = type

      non_s3_fs_finder = lambda do |paths|
        ([@filesystem] * paths.size).zip(paths).flatten
      end

      s3_fs_finder = lambda do |paths|
        paths.map do |path|
          %r{
            (?:(?<protocol>s3n?):\/\/)?
            (?<bucket>[^\/]*)
            (?<fs_path>\/.*$)
          }x =~ path

          # ignore user-specified protocol, if any
          protocol = @type.to_s

          fs_uri = Java::java.net.URI.new("#{protocol}://#{bucket}")
          [get_fs(fs_uri), fs_path]
        end.flatten
      end

      case type
      when :local
        fs_uri = Java::java.net.URI.new("file:///")
        @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(fs_uri, @conf)
        @find_fs = non_s3_fs_finder
      when :hdfs
        @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(@conf)
        @find_fs = non_s3_fs_finder
      when :s3n
        @filesystems = {}
        @find_fs = s3_fs_finder
      when :s3
        @filesystems = {}
        @find_fs = s3_fs_finder
      end
    end
    
    def self.fs_method(symb)
      define_method(symb) { |*paths| yield *@find_fs.call(paths) }
    end

    def get_fs uri
      @filesystems[uri] ||= Java::org.apache.hadoop.fs.FileSystem.get(uri,
                                                                      @conf)
    end

    fs_method :glob do |fs, glob|
      fs.glob_status(Java::org.apache.hadoop.fs.Path.new(glob)).map do |f|
        f.get_path.to_s
      end
    end
  end
end
