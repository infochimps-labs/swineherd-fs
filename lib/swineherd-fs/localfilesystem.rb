module Swineherd
  class LocalFileSystem
    #include Swineherd::BaseFileSystem

    def initialize *args
    end

    def open path, mode="r", &blk
      File.open(path,mode,&blk)
    end

    #Globs for files at @path@, append '**/*' to glob recursively
    def size path
      Dir[path].inject(0){|s,f|s+=File.size(f)}
    end

    #A leaky abstraction, should be called rm_rf if it calls rm_rf
    def rm_r path
      FileUtils.rm_rf path
    end

    def rm path
      FileUtils.rm path
    end

    def exists? path
      File.exists?(path)
    end

    def directory? path
      File.directory? path
    end

    def mv srcpath, dstpath
      FileUtils.mv(srcpath,dstpath)
    end

    def cp srcpath, dstpath
      FileUtils.cp(srcpath,dstpath)
    end

    def cp_r srcpath, dstpath
      FileUtils.cp_r(srcpath,dstpath)
    end

    def mkdir_p path
      FileUtils.mkdir_p path
    end

    #List directory contents,similar to unix `ls`
    #Dir[@path@/*] to return files in immediate directory of @path@
    def ls path
      if exists?(path)
        if !directory?(path)
          [path]
        else
          path += '/' unless path =~ /\/$/
          Dir[path+'*']
        end
      else
        raise Errno::ENOENT, "No such file or directory - #{path}"
      end
    end

    #Recursively list directory contents
    #Dir[@path@/**/*],similar to unix `ls -R`
    def ls_r path
      if exists?(path)
        if !directory?(path)
          [path]
        else
          path += '/' unless path =~ /\/$/
          Dir[path+'**/*']
        end
      else
        raise Errno::ENOENT, "No such file or directory - #{path}"
      end
    end

  end
end
