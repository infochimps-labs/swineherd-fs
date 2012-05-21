require 'forwardable'
require 'java'
require 'open-uri'

module Swineherd
  class FileSystem

    attr_reader :type, :filesystems
    protected :type, :filesystems

    def initialize *args
      raise NoMethodError.new "Use Swineherd::FileSystem.get to construct me."
    end

    def init_parent type
      Swineherd.configure_hadoop_jruby
      @conf = Swineherd.get_hadoop_conf
      @type = type
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
                raise ArgumentError.new("wrong type of fs: #{@type} has type "\
                                        "#{@type.class}")
              end

      case @type
      when :local then LocalFileSystem.new @type
      when :hdfs then HadoopFileSystem.new @type
      when :s3n then S3FileSystem.new @type 
      when :s3 then S3FileSystem.new @type
      end
    end

    #
    # This can be overridden in cases where the Ruby FileSystem class
    # does not correspond exactly to a Java FileSystem class. The S3
    # and S3 native filesystems are currently the only examples.
    #
    def get_fs uri
      @filesystem
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
      fs = get_fs path
      HadoopFile.new(path, mode, fs, &blk)
    end

    def glob glb
      fs = get_fs glb
      path = Java::org.apache.hadoop.fs.Path.new(glb)
      
      # For some reason, toArray is sometimes returning null in the
      # Hadoop FileSystem.globStatus method, causing jruby to return
      # nil. That shouldn't happen, but this will handle it.
      (fs.glob_status(path) || []).map{|f| f.get_path.to_s }
    end
  end
end
