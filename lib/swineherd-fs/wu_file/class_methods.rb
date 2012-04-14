module Wukong
  class WuFile
    class << self

      #
      # Returns a `File::Stat` object for the named file (see `File::Stat`).
      #
      # @example `File.stat(filename) -> stat`
      #    File.stat("testfile").mtime   #=> Tue Apr 08 12:58:04 CDT 2003
      #
      def stat(filename)
        NoMethodError.abstract(self)
      end

      #
      # Identifies the type of the named file
      #
      # @return ["file", "directory", "characterSpecial", "blockSpecial", "fifo", "link", "socket", "unknown"]
      #
      # @example `File.ftype(filename) -> string`
      #   File.ftype("testfile")            #=> "file"
      #   File.ftype("/dev/tty")            #=> "characterSpecial"
      #   File.ftype("/tmp/.X11-unix/X0")   #=> "socket"
      #
      def ftype(filename)
        NoMethodError.abstract(self)
      end

      #
      # an integer representing the permission bits of *stat*. The meaning of the bits
      # is platform dependent; on Unix systems, see `stat(2)`.'
      #
      def mode(filename)
        NoMethodError.abstract(self)
      end

      # Returns the size of `filename`.
      #
      def size(filename)
        NoMethodError.abstract(self)
      end

      def blocks(filename)
      end

      def blksize(filename)
      end

      #
      # Returns the last access time for the named file as a Time object.
      #
      # @example `File.atime(filename) -> time`
      #   File.atime("testfile")   #=> Wed Apr 09 08:51:48 CDT 2003
      #
      def atime(filename)
        NoMethodError.abstract(self)
      end

      #
      # Returns the change time for the named file (the time at which directory
      # information about the file was changed, not the file itself).
      #
      # @example `File.ctime(filename) -> time`
      #   File.ctime("testfile")   #=> Tue Apr 08 12:58:04 CDT 2003
      #
      def ctime(filename)
        NoMethodError.abstract(self)
      end

      #
      # Returns the modification time for the named file as a Time object.
      #
      # @example `File.mtime(filename) -> time`
      #   File.mtime("testfile")   #=> Tue Apr 08 12:58:04 CDT 2003
      #
      def mtime(filename)
        NoMethodError.abstract(self)
      end

      def uid(filename)
      end

      def gid(filename)
      end

      # __________________________________________________________________________

      #
      # Changes permission bits on the named file(s) to the bit pattern represented by
      # *mode_int*. Actual effects are operating system dependent (see the beginning
      # of this section). On Unix systems, see `chmod(2)` for details. Returns the
      # number of files processed.
      #
      # @example `File.chmod(mode_int, *filenames) -> integer`
      #   File.chmod(0644, "testfile", "out")   #=> 2
      #
      def chmod(mode_int,filename, *args)
        NoMethodError.abstract(self)
      end

      #
      # Equivalent to `File::chmod`, but does not follow symbolic links (so it will
      # change the permissions associated with the link, not the file referenced by
      # the link). Often not available.
      #
      # @example `File.lchmod(mode_int, *filenames) -> integer`
      #   File.chmod(0644, "testfile", "out")   #=> 2
      #
      def lchmod(mode_int, *filenames)
        NoMethodError.abstract(self)
      end

      #
      # Changes the owner and group of the named file(s) to the given numeric owner
      # and group id's. Only a process with superuser privileges may change the owner
      # of a file. The current owner of a file may change the file's group to any
      # group to which the owner belongs. A `nil` or -1 owner or group id is ignored.
      # Returns the number of files processed.
      #
      # @example `File.chown(owner_id, group_id, filenames) -> integer`
      #   File.chown(nil, 100, "testfile")
      #
      def chown(owner_id, group_id, *filenames)
        NoMethodError.abstract(self)
      end

      #
      # Creates a new name for an existing file using a hard link. Will not overwrite
      # *new_name* if it already exists (raising a subclass of `SystemCallError`). Not
      # available on all platforms.
      #
      # @example `File.link(old_name, new_name) -> 0`
      #   File.link("testfile", ".testfile")   #=> 0
      #   IO.readlines(".testfile")[0]         #=> "This is line one\n"
      #
      def link(old_name, new_name)
        NoMethodError.abstract(self)
      end

      #
      # Creates a symbolic link called *new_name* for the existing file
      # *old_name*. Raises a `NotImplemented` exception on platforms that do not
      # support symbolic links.
      #
      # @example `File.symlink(old_name, new_name) -> 0`
      #   File.symlink("testfile", "link2test")   #=> 0
      #
      def symlink(old_name, new_name)
        NoMethodError.abstract(self)
      end

      #
      # Returns the name of the file referenced by the given link.  Not available on
      # all platforms.
      #
      # @example `File.readlink(link_name) -> filename`
      #   File.symlink("testfile", "link2test")   #=> 0
      #   File.readlink("link2test")              #=> "testfile"
      #
      def readlink(link_name)
        NoMethodError.abstract(self)
      end

      #
      # Deletes the named files, returning the number of names passed as
      # arguments. Raises an exception on any error.  See also `Dir::rmdir`.
      #
      #     File.delete(*filenames) -> integer
      #     File.unlink(*filenames) -> integer
      #
      def delete(*filename)
        NoMethodError.abstract(self)
      end

      #
      # Renames the given file to the new name. Raises a
      # `SystemCallError` if the file cannot be renamed.
      #
      # @example `File.rename(old_name, new_name) -> 0`
      #   File.rename("afile", "afile.bak")   #=> 0
      #
      def rename(old_name, new_name)
        NoMethodError.abstract(self)
      end

      #
      # Sets the access and modification times of each named file to the first two
      # arguments. Returns the number of file names in the argument list.
      #
      # @example `File.utime(atime, mtime, *filenames) -> integer`
      #   Time.now #=> Tue Apr 08 12:58:04 CDT 2003
      #   File.utime(Time.now - 3600, Time.now - 60, "testfile") #=> 1
      #   File.atime("testfile")   #=> Tue Apr 08 11:58:04 CDT 2003
      #   File.mtime("testfile")   #=> Tue Apr 08 12:57:04 CDT 2003
      #
      def utime(atime, mtime, *filenames)
        NoMethodError.abstract(self)
      end

      #
      # Returns the current umask value for this process. If the optional
      # argument is given, set the umask to that value and return the
      # previous value. Umask values are *subtracted* from the
      # default permissions, so a umask of `0222` would make a
      # file read-only for everyone.
      #
      # @example File.umask() -> integer
      #   File.umask(0006)   #=> 18
      # @example File.umask(integer) -> integer
      #   File.umask         #=> 6
      #
      def umask()
        NoMethodError.abstract(self)
      end

      #
      # Converts a pathname to an absolute pathname. Relative paths are referenced
      # from the current working directory of the process unless *dir_string* is
      # given, in which case it will be used as the starting point. The given pathname
      # may start with a "~", which expands to the process owner's home directory (the
      # environment variable `HOME` must be set correctly). "~`*user*'' expands to the
      # named user's home directory.
      #
      #     File.expand_path(filename[, dir_string] ) -> abs_filename
      #
      # @example shell expansion
      #   File.expand_path("~oracle/bin")           #=> "/home/oracle/bin"
      # @example Relative paths
      #   File.expand_path("../../bin", "/tmp/x")   #=> "/bin"
      #
      def expand_path(filename, dir_string=nil)
        NoMethodError.abstract(self)
      end

      #
      # Converts a pathname to an absolute pathname. Relative paths are
      # referenced from the current working directory of the process unless
      # *dir_string* is given, in which case it will be used as the
      # starting point. If the given pathname starts with a "~"
      # it is NOT expanded, it is treated as a normal directory name.
      #
      #     File.absolute_path(filename[, dir_string] ) -> abs_filename
      #
      # @example
      #   File.absolute_path("~oracle/bin")       #=> "<relative_path>/~oracle/bin"
      #
      def absolute_path(filename, dir_string=nil)
        NoMethodError.abstract(self)
      end

      #
      # Returns the real (absolute) pathname of _pathname_ in the actual filesystem
      # not containing symlinks or useless dots.
      #
      # If _dir_string_ is given, it is used as a base directory for interpreting
      # relative pathname instead of the current directory.
      #
      # All components of the pathname must exist when this method is called.
      #
      #   File.realpath(pathname[, dir_string]) -> real_pathname
      #
      def realpath(pathname, dir_string=nil)
        NoMethodError.abstract(self)
      end

      #
      # Returns the real (absolute) pathname of _pathname_ in the actual filesystem.
      # The real pathname doesn't contain symlinks or useless dots.
      #
      # If _dir_string_ is given, it is used as a base directory for interpreting
      # relative pathname instead of the current directory.
      #
      # The last component of the real pathname can be nonexistent.
      #
      #   File.realdirpath(pathname[, dir_string]) -> real_pathname
      #
      def realdirpath(pathname, dir_string=nil)
        NoMethodError.abstract(self)
      end

      #
      # Returns the last component of the filename given in *filename*, which must be
      # formed using forward slashes ("/") regardless of the separator used on the
      # local file system. If *suffix* is given and present at the end of *filename*,
      # it is removed.
      #
      # @example `File.basename(filename[, suffix] ) -> base_name`
      #   File.basename("/home/gumby/work/ruby.rb")          #=> "ruby.rb"
      #   File.basename("/home/gumby/work/ruby.rb", ".rb")   #=> "ruby"
      #
      def basename(filename, suffix=nil)
        NoMethodError.abstract(self)
      end

      #
      # Returns all components of the filename given in *filename* except the last
      # one. The filename must be formed using forward slashes ("/") regardless of the
      # separator used on the local file system.
      #
      # @example `File.dirname(filename) -> dir_name`
      #   File.dirname("/home/gumby/work/ruby.rb")   #=> "/home/gumby/work"
      #
      def dirname(filename)
        NoMethodError.abstract(self)
      end

      #
      # accept a String, and return the pointer of the extension.  if len is passed,
      # set the length of extension to it.  returned pointer is in ``name'' or NULL.
      #
      #     File.extname(path) -> string
      #
      #                    returns   *len
      #      no dot        NULL      0
      #      dotfile       top       0
      #      end with dot  dot       1
      #      .ext          dot       len of .ext
      #      .ext:stream   dot       len of .ext without :stream (NT only)
      #
      # Returns the extension (the portion of file name in *path* after the period).
      #
      # @example
      #   File.extname("test.rb")         #=> ".rb"
      #   File.extname("a/b/d/test.rb")   #=> ".rb"
      #   File.extname("test")            #=> ""
      #   File.extname(".profile")        #=> ""
      #
      def extname(path)
        NoMethodError.abstract(self)
      end

      #
      # Returns the string representation of the path
      #
      # @example `File.path(path) -> string`
      #   File.path("/dev/null")          #=> "/dev/null"
      #   File.path(Pathname.new("/tmp")) #=> "/tmp"
      #
      def path(path)
        NoMethodError.abstract(self)
      end

      #
      # Splits the given string into a directory and a file component and returns them
      # in a two-element array. See also `File::dirname` and `File::basename`.
      #
      # @example `File.split(filename) -> array`
      #   File.split("/home/gumby/.profile")   #=> ["/home/gumby", ".profile"]
      #
      def split(filename)
        NoMethodError.abstract(self)
      end

      #
      # Returns a new string formed by joining the strings using `File::SEPARATOR`.
      #
      # @example `File.join(path_segs) -> path`
      #   File.join("usr", "mail", "gumby")   #=> "usr/mail/gumby"
      #
      def join(*strings)
        NoMethodError.abstract(self)
      end

      #
      # Truncates the file *filename* to be at most *integer* bytes long. Not
      # available on all platforms.
      #
      # @example Truncating with a length `File.truncate(filename, bytes) -> 0`
      #   f = File.new("out", "w")
      #   f.write("1234567890")     #=> 10
      #   f.close                   #=> nil
      #   File.truncate("out", 5)   #=> 0
      #   File.size("out")          #=> 5
      #
      def truncate(filename, bytes)
        NoMethodError.abstract(self)
      end
    end
  end
end
