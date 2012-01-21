module Swineherd

  #
  # Methods for interacting with Amazon's Simple Store Service (S3).
  #
  class S3FileSystem

    attr_accessor :s3

    def initialize options={}
      aws_access_key = options[:aws_access_key] || (Swineherd.config[:aws] && Swineherd.config[:aws][:access_key])
      aws_secret_key = options[:aws_secret_key] || (Swineherd.config[:aws] && Swineherd.config[:aws][:secret_key])
      raise "Missing AWS keys" unless aws_access_key && aws_secret_key
      @s3 = RightAws::S3.new(aws_access_key, aws_secret_key,:logger => Logger.new(nil)) #FIXME: Just wanted it to shut up
    end

    def open path, mode="r", &blk
      S3File.new(path,mode,self,&blk)
    end

    def size path
      if directory?(path)
        ls_r(path).inject(0){|sum,file| sum += filesize(file)}
      else
        filesize(path)
      end
    end

    def rm path
      bkt,key = split_path(path)
      if key.empty? || directory?(path)
        raise Errno::EISDIR,"#{path} is a directory or bucket, use rm_r or rm_bucket"
      else
        @s3.interface.delete(bkt, key)
      end
    end

    #rm_r - Remove recursively. Does not delete buckets, use rm_bucket
    #params: @path@ - Path of file or folder to delete
    #returns: Array - Array of paths which were deleted
    def rm_r path
      bkt,key = split_path(path)
      if key.empty?
        # only the bucket was passed in
      else
        if directory?(path)
          @s3.interface.delete_folder(bkt,key).flatten
        else
          @s3.interface.delete(bkt, key)
          [path]
        end
      end
    end

    def rm_bucket bucket_name
      @s3.interface.force_delete_bucket(bucket_name)
    end

    def exists? path
      bucket,key = split_path(path)
      begin
        if key.empty? #only a bucket was passed in, check if it exists
          #FIXME: there may be a better way to test, relying on error to be raised here
          @s3.interface.bucket_location(bucket) && true
        elsif file?(path) #simply test for existence of the file
          true
        else #treat as directory and see if there are files beneath it
          #if it's not a file, it is harmless to add '/'.
          #the prefix search may return files with the same root extension,
          #ie. foo.txt and foo.txt.bak, if we leave off the trailing slash
          key+="/" unless key =~ /\/$/
          @s3.interface.list_bucket(bucket,:prefix => key).size > 0
        end
      rescue RightAws::AwsError => error
        if error.message =~ /nosuchbucket/i
          false
        elsif error.message =~ /not found/i
          false
        else
          raise
        end
      end
    end

    def directory? path
      exists?(path) && !file?(path)
    end

    def file? path
      bucket,key = split_path(path)
      begin
        return false if (key.nil? || key.empty?) #buckets are not files
        #FIXME: there may be a better way to test, relying on error to be raised
        @s3.interface.head(bucket,key) && true
      rescue RightAws::AwsError => error
        if error.message =~ /nosuchbucket/i
          false
        elsif  error.message =~ /not found/i
          false
        else
          raise
        end
      end
    end

    def mv srcpath, dstpath
      src_bucket,src_key_path = split_path(srcpath)
      dst_bucket,dst_key_path = split_path(dstpath)
      mkdir_p(dstpath) unless exists?(dstpath)
      if directory? srcpath
        paths_to_copy = ls_r(srcpath)
        common_dir    = common_directory(paths_to_copy)
        paths_to_copy.each do |path|
          bkt,key = split_path(path)
          src_key = key
          dst_key = File.join(dst_key_path, path.gsub(common_dir, ''))
          @s3.interface.move(src_bucket, src_key, dst_bucket, dst_key)
        end
      else
        @s3.interface.move(src_bucket, src_key_path, dst_bucket, dst_key_path)
      end
    end

    def cp srcpath, dstpath
      src_bucket,src_key_path = split_path(srcpath)
      dst_bucket,dst_key_path = split_path(dstpath)
      mkdir_p(dstpath) unless exists?(dstpath)
      if src_key_path.empty? || directory?(srcpath)
        raise Errno::EISDIR,"#{srcpath} is a directory or bucket, use cp_r"
      else
        @s3.interface.copy(src_bucket, src_key_path, dst_bucket, dst_key_path)
      end
    end

    # mv is just a special case of cp_r...this is a waste
    def cp_r srcpath, dstpath
      src_bucket,src_key_path = split_path(srcpath)
      dst_bucket,dst_key_path = split_path(dstpath)
      mkdir_p(dstpath) unless exists?(dstpath)
      if directory? srcpath
        paths_to_copy = ls_r(srcpath)
        common_dir    = common_directory(paths_to_copy)
        paths_to_copy.each do |path|
          bkt,key = split_path(path)
          src_key = key
          dst_key = File.join(dst_key_path, path.gsub(common_dir, ''))
          @s3.interface.copy(src_bucket, src_key, dst_bucket, dst_key)
        end
      else
        @s3.interface.copy(src_bucket, src_key_path, dst_bucket, dst_key_path)
      end
    end

    #This is a bit funny, there's actually no need to create a 'path' since
    #s3 is nothing more than a glorified key-value store. When you create a
    #'file' (key) the 'path' will be created for you. All we do here is create
    #the bucket unless it already exists.
    def mkdir_p path
      bkt,key = split_path(path)
      @s3.interface.create_bucket(bkt) unless exists? path
    end

    def ls path
      if exists?(path)
        bkt,prefix = split_path(path)
        prefix += '/' if directory?(path) && !(prefix =~ /\/$/) && !prefix.empty?
        contents = []
        @s3.interface.incrementally_list_bucket(bkt, {'prefix' => prefix,:delimiter => '/'}) do |res|
          contents += res[:common_prefixes].map{|c| File.join(bkt,c)}
          contents += res[:contents].map{|c| File.join(bkt, c[:key])}
        end
        contents
      else
        raise Errno::ENOENT, "No such file or directory - #{path}"
      end
    end

    def ls_r path
      if(file?(path))
        [path]
      else
        ls(path).inject([]){|paths,path| paths << path if directory?(path);paths << ls_r(path)}.flatten
      end
    end

    # FIXME: Not implemented for directories
    # @srcpath@ is assumed to be on the local filesystem
    def copy_from_local srcpath, destpath
      bucket,key = split_path(destpath)
      if File.exists?(srcpath)
        if File.directory?(srcpath)
          raise "NotYetImplemented"
        else
          @s3.interface.put(bucket, key, File.open(srcpath))
        end
      else
        raise Errno::ENOENT, "No such file or directory - #{srcpath}"
      end
    end
#    alias :put :copy_from_local

    #FIXME: Not implemented for directories
    def copy_to_local srcpath, dstpath
      src_bucket,src_key_path = split_path(srcpath)
      dstfile = File.new(dstpath, 'w')
      @s3.interface.get(src_bucket, src_key_path) do |chunk|
        dstfile.write(chunk)
      end
      dstfile.close
    end
#    alias :get :copy_to_local

    def bucket path
      #URI.parse(path).path.split('/').reject{|x| x.empty?}.first
      split_path(path).first
    end

    def key_for path
      #File.join(URI.parse(path).path.split('/').reject{|x| x.empty?}[1..-1])
      split_path(path).last
    end

    def split_path path
      uri = URI.parse(path)
      base_uri = ""
      base_uri << uri.host if uri.scheme
      base_uri << uri.path
      path = base_uri.split('/').reject{|x| x.empty?}
      [path[0],path[1..-1].join("/")]
    end

    private

    # FIXME: This is dense
    def common_directory paths
      dirs     = paths.map{|path| path.split('/')}
      min_size = dirs.map{|splits| splits.size}.min
      dirs     = dirs.map{|splits| splits[0...min_size]}
      uncommon_idx = dirs.transpose.each_with_index.find{|dirnames, idx| dirnames.uniq.length > 1}.last
      dirs[0][0...uncommon_idx].join('/')
    end

    def filesize filepath
      bucket,key = split_path(filepath)
      header = @s3.interface.head(bucket, key)
      header['content-length'].to_i
    end

    class S3File
      attr_accessor :path, :handle, :fs

      #
      # In order to open input and output streams we must pass around the s3 fs object itself
      #
      def initialize path, mode, fs, &blk
        @fs   = fs
        @path = path
        case mode
        when "r" then
          #          raise "#{fs.type(path)} is not a readable file - #{path}" unless fs.type(path) == "file"
        when "w" then
          #          raise "Path #{path} is a directory." unless (fs.type(path) == "file") || (fs.type(path) == "unknown")
          @handle = Tempfile.new('s3filestream')
          if block_given?
            yield self
            close
          end
        end
      end

      #
      # Faster than iterating
      #
      def read
        bucket,key = fs.split_path(path)
        fs.s3.interface.get_object(bucket, key)
      end

      #
      # This is a little hackety. That is, once you call (.each) on the object the full object starts
      # downloading...
      #
      def readline
        bucket,key = fs.split_path(path)
        @handle ||= fs.s3.interface.get_object(bucket, key).each
        begin
          @handle.next
        rescue StopIteration, NoMethodError
          @handle = nil
          raise EOFError.new("end of file reached")
        end
      end

      def write string
        @handle.write(string)
      end

      def close
        bucket,key = fs.split_path(path)
        if @handle
          @handle.read
          fs.s3.interface.put(bucket, key, File.open(@handle.path, 'r'))
          @handle.close
        end
        @handle = nil
      end

    end

  end
end
