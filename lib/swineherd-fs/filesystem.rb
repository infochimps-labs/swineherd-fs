require 'forwardable'
require 'java'
require 'open-uri'

module Swineherd
  class FileSystem

    attr_reader :type, :filesystems
    protected :type, :filesystems

    def initialize
      @hadoop_home = ENV['HADOOP_HOME']

      hadoop_conf = (ENV['HADOOP_CONF_DIR'] || File.join(@hadoop_home, 'conf'))
      hadoop_conf += "/" unless hadoop_conf.end_with? "/"
      $CLASSPATH << hadoop_conf unless $CLASSPATH.include?(hadoop_conf)
      
      Dir["#{@hadoop_home}/{hadoop*.jar,lib/*.jar}"].each{|jar| require jar}
      
      begin
        require 'java'
      rescue LoadError => e
        raise "\nJava not found. Are you sure you're running with JRuby?\n" +
          e.message
      end
      raise "\nHadoop installation not found. Try setting $HADOOP_HOME\n" unless
        (@hadoop_home and (File.exist? @hadoop_home))
      true

      @conf = Java::org.apache.hadoop.conf.Configuration.new

      if Swineherd.config[:aws]
        @conf.set("fs.s3.awsAccessKeyId",Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])

        @conf.set("fs.s3n.awsAccessKeyId",Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3n.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])
      end
    end

    #
    # If no path is provided, a filesystem will be generated using the
    # default hadoop configuration.
    #
    def self.get fs = :hdfs

      @type = case fs
              when String
                m = /([^:]*):\/\//.match(fs)
                m ? m[1].to_sym : :hdfs
              when Symbol then fs
              else
                require 'pp'; pp @type.class
                raise ArgumentError.new "wrong type of fs"
              end

      @type = :local if @type == :file

      case @type
      when :local then LocalFileSystem.new
      when :hdfs then HadoopFileSyste.new
      when :s3n then S3FileSystem.new
      when :s3 then S3FileSystem.new
      end
    end

    #
    # This can be overridden in cases where the Ruby FileSystem class
    # does not correspond exactly to a Java FileSystem class. The S3
    # and S3 native filesystems are currently the only examples.
    #
    def get_fs uri
      return @filesystem
    end

    class HadoopFile
      extend Forwardable

      def_delegators(:@stream, :read, :close)

      def initialize path, mode, fs, &blk
        @path = Java::org.apache.hadoop.fs.Path.new path
        raise Errno::EISDIR,"#{path} is a directory" if
          (fs.exists(@path) and fs.get_file_status(@path).is_dir)
           

        case mode
        when "r" then @stream = fs.open(@path).to_io(&blk)
        when "w"
          @stream = fs.create(@path).to_io.to_outputstream
          if block_given?
            yield self
            self.close
          end
        end
      end

      def write string
        @handle.write(string.to_java_string.get_bytes)
      end

      def path
        @path.toString
      end
    end

    def open path, mode="r", &blk
      fs = get_fs
      HadoopFile.new(path, mode, fs, &blk)
    end

    def glob glb
      fs = get_fs glb
      path = Java::org.apache.hadoop.fs.Path.new(glb)
      
      # For some reason, toArray is sometimes returning null in the
      # Hadoop FileSystem.globStatus method, causing jruby to return
      # nil. That shouldn't happen, but this will handle it.
      (fs.glob_status(path) || []).map do |f|
        f.get_path.to_s
      end
    end
  end

  class LocalFileSystem
    def initialize
      fs_uri = Java::java.net.URI.new("file:///")
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(fs_uri, @conf)
      super
    end
  end

  class HadoopFileSystem
    def initialize
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(@conf)
      super
    end
  end

  class S3FileSystem
    def initialize
      @filesystems = {}
      super
    end
    
    def get_fs path
      %r{
            (?:(?<protocol>s3n?):\/\/)?
            (?<bucket>[^\/]*)
            (?<fs_path>\/.*$)
        }x =~ path

      # ignore user-specified protocol, if any
      protocol = type.to_s

      fs_uri = Java::java.net.URI.new("#{protocol}://#{bucket}")
      [get_fs(fs_uri), fs_path]
      
      @filesystems[uri] ||= Java::org.apache.hadoop.fs.FileSystem.get(uri,
                                                                      @conf)
    end
  end
end
