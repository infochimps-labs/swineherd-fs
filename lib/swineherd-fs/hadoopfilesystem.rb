module Swineherd

  #
  # Methods for dealing with the Hadoop distributed file system (hdfs). This class
  # requires that you run with JRuby as it makes use of the native Java Hadoop
  # libraries.
  #
  class HadoopFileSystem

    attr_accessor :conf, :hdfs

    def initialize *args
      set_hadoop_environment if running_jruby?

      @conf = Java::org.apache.hadoop.conf.Configuration.new

      if Swineherd.config[:aws]
        @conf.set("fs.s3.awsAccessKeyId",      Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3.awsSecretAccessKey",  Swineherd.config[:aws][:secret_key])
        @conf.set("fs.s3n.awsAccessKeyId",     Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3n.awsSecretAccessKey", Swineherd.config[:aws][:secret_key])
      end

      @hdfs = Java::org.apache.hadoop.fs.FileSystem.get(@conf)
    end

    def open path, mode="r", &blk
      HadoopFile.new(path, mode, self, &blk)
    end

    def size path
      ls_r(path).inject(0){|sz, filepath| sz += @hdfs.get_file_status(Path.new(filepath)).get_len}
    end

    def ls path
      (@hdfs.list_status(Path.new(path)) || []).map{|path| path.get_path.to_s}
    end

    #list directories recursively, similar to unix 'ls -R'
    def ls_r path
      ls(path).inject([]){|rec_paths, path| rec_paths << path; rec_paths << ls(path) unless file?(path); rec_paths}.flatten
    end

    def rm path
      begin
        @hdfs.delete(Path.new(path), false)
      rescue java.io.IOException => err
        raise Errno::EISDIR, err.message, err.backtrace
      end
    end

    def rm_r path
      @hdfs.delete(Path.new(path), true)
    end

    def exists? path
      @hdfs.exists(Path.new(path))
    end

    def directory? path
      exists?(path) && @hdfs.get_file_status(Path.new(path)).is_dir?
    end

    def file? path
      exists?(path) && @hdfs.isFile(Path.new(path))
    end

    def mv srcpath, dstpath
      @hdfs.rename(Path.new(srcpath), Path.new(dstpath))
    end

    #supports s3://, s3n://, hdfs:// in @srcpath@ and @dstpath@
    def cp srcpath, dstpath
      @src_fs  = Java::org.apache.hadoop.fs.FileSystem.get(Java::JavaNet::URI.create(srcpath), @conf)
      @dest_fs = Java::org.apache.hadoop.fs.FileSystem.get(Java::JavaNet::URI.create(dstpath), @conf)
      FileUtil.copy(@src_fs, Path.new(srcpath), @dest_fs, Path.new(dstpath), false, @conf)
    end

    def cp_r srcpath, dstpath
      cp srcpath, dstpath
    end

    def mkdir_p path
      @hdfs.mkdirs(Path.new(path))
    end

    #
    # Copy hdfs file to local filesystem
    #
    def copy_to_local srcfile, dstfile
      @hdfs.copy_to_local_file(Path.new(srcfile), Path.new(dstfile))
    end
#    alias :get :copy_to_local

    #
    # Copy local file to hdfs filesystem
    #
    def copy_from_local srcfile, dstfile
      @hdfs.copy_from_local_file(Path.new(srcfile), Path.new(dstfile))
    end
    #    alias :put :copy_from_local


    #
    # Merge all part files in a directory into one file.
    #
    def merge srcdir, dstfile
      FileUtil.copy_merge(@hdfs, Path.new(srcdir), @hdfs, Path.new(dstfile), false, @conf, "")
    end

    #
    # This is hackety. Use with caution.
    #
    def stream input, output
      input_fs_scheme  = (Java::JavaNet::URI.create(input).scheme || "file") + "://"
      output_fs_scheme = (Java::JavaNet::URI.create(output).scheme || "file") + "://"
      system("#{@hadoop_home}/bin/hadoop \\
       jar         #{@hadoop_home}/contrib/streaming/hadoop-*streaming*.jar                     \\
       -D          mapred.job.name=\"Stream { #{input_fs_scheme}(#{File.basename(input)}) -> #{output_fs_scheme}(#{File.basename(output)}) }\" \\
       -D          mapred.min.split.size=1000000000                                            \\
       -D          mapred.reduce.tasks=0                                                       \\
       -mapper     \"/bin/cat\"                                                                \\
       -input      \"#{input}\"                                                                \\
       -output     \"#{output}\"")
    end

    #
    # BZIP
    #
    def bzip input, output
      system("#{@hadoop_home}/bin/hadoop \\
       jar         #{@hadoop_home}/contrib/streaming/hadoop-*streaming*.jar     \\
       -D          mapred.output.compress=true                                  \\
       -D          mapred.output.compression.codec=org.apache.hadoop.io.compress.BZip2Codec  \\
       -D          mapred.reduce.tasks=1                                        \\
       -mapper     \"/bin/cat\"                                                 \\
       -reducer    \"/bin/cat\"                                                 \\
       -input      \"#{input}\"                                                 \\
       -output     \"#{output}\"")
    end

    #
    # Merges many input files into :reduce_tasks amount of output files
    #
    def dist_merge inputs, output, options = {}
      options[:reduce_tasks]     ||= 25
      options[:partition_fields] ||= 2
      options[:sort_fields]      ||= 2
      options[:field_separator]  ||= '/t'
      names = inputs.map{|inp| File.basename(inp)}.join(', ')
      cmd   = "#{@hadoop_home}/bin/hadoop \\
       jar         #{@hadoop_home}/contrib/streaming/hadoop-*streaming*.jar                   \\
       -D          mapred.job.name=\"Swineherd Merge (#{names} -> #{output})\"               \\
       -D          num.key.fields.for.partition=\"#{options[:partition_fields]}\"            \\
       -D          stream.num.map.output.key.fields=\"#{options[:sort_fields]}\"             \\
       -D          mapred.text.key.partitioner.options=\"-k1, #{options[:partition_fields]}\" \\
       -D          stream.map.output.field.separator=\"'#{options[:field_separator]}'\"      \\
       -D          mapred.min.split.size=1000000000                                          \\
       -D          mapred.reduce.tasks=#{options[:reduce_tasks]}                             \\
       -partitioner org.apache.hadoop.mapred.lib.KeyFieldBasedPartitioner                    \\
       -mapper     \"/bin/cat\"                                                              \\
       -reducer    \"/usr/bin/uniq\"                                                         \\
       -input      \"#{inputs.join(', ')}\"                                                   \\
       -output     \"#{output}\""
      puts cmd
      system cmd
    end

    class HadoopFile
      attr_accessor :handle

      #
      # In order to open input and output streams we must pass around the hadoop fs object itself
      #
      def initialize path, mode, fs, &blk
        raise Errno::EISDIR, "#{path} is a directory" if fs.directory?(path)
        @path = Path.new(path)
        case mode
        when "r"
          @handle = fs.hdfs.open(@path).to_io(&blk)
        when "w"
          @handle = fs.hdfs.create(@path).to_io.to_outputstream
          if block_given?
            yield self
            self.close
          end
        end
      end

      def path
        @path.toString()
      end

      def read
        @handle.read
      end

      def write string
        @handle.write(string.to_java_string.get_bytes)
      end

      def close
        @handle.close
      end

    end

    private

    # Check that we are running with jruby, check for hadoop home.
    def running_jruby?
      begin
        require 'java'
      rescue LoadError => err
        raise LoadError, "\nJava not found, are you sure you're running with JRuby?\n#{err.message}", err.backtrace
      end
      @hadoop_home = ENV['HADOOP_HOME']
      raise "\nHadoop installation not found, try setting $HADOOP_HOME\n" unless @hadoop_home && (File.exist? @hadoop_home)
      true
    end

    #
    # Place hadoop jars in class path, require appropriate jars, set hadoop conf
    #

    def set_classpath
      hadoop_conf = (ENV['HADOOP_CONF_DIR'] || File.join(@hadoop_home, 'conf'))
      hadoop_conf += "/" unless hadoop_conf.end_with? "/"
      $CLASSPATH << hadoop_conf unless $CLASSPATH.include?(hadoop_conf)
    end

    def import_classes
      Dir["#{@hadoop_home}/hadoop*.jar", "#{@hadoop_home}/lib/*.jar"].each{|jar| require jar}
      [ 'org.apache.hadoop.fs.Path',
        'org.apache.hadoop.fs.FileUtil',
        'org.apache.hadoop.mapreduce.lib.input.FileInputFormat',
        'org.apache.hadoop.mapreduce.lib.output.FileOutputFormat',
        'org.apache.hadoop.fs.FSDataOutputStream',
        'org.apache.hadoop.fs.FSDataInputStream'].map{|j_class| java_import(j_class) }
    end

    def set_hadoop_environment
      set_classpath
      import_classes
    end

  end
end
