require 'java'
require 'open-uri'

module Swineherd
  class FileSystem

    class HadoopPath
      def initialize child, prefix
        @child = child
        @prefix = prefix
      end

      def glob path
        @child.glob File.join(@prefix, path)
      end

      def to_s
        return @prefix
      end
      
    end

    instance_eval do
      def wrap_fs_methods *symbols
        symbols.each do |symbol|
          old_method = "#{symbol}_handler".to_sym
          define_method symbol do |*paths|
            params = @find_fs.call paths
            self.send old_method, *params
          end
        end
      end
    end

    #
    # If no path is provided, a filesystem will be generated using the
    # default hadoop configuration.
    #
    def initialize type = :hdfs
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

    def get_fs uri
      @filesystems[uri] ||= Java::org.apache.hadoop.fs.FileSystem.get(uri,
                                                                      @conf)
    end

    wrap_fs_methods :glob

    def glob_handler fs, glob
      files = fs.glob_status Java::org.apache.hadoop.fs.Path.new(glob)
      (files || []).map { |f| HadoopPath.new(self, f.get_path.to_s) }
    end
  end
end
