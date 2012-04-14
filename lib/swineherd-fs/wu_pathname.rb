module Wukong
  #
  # == WuPathname
  #
  # Pathname represents a pathname which locates a file in a filesystem.
  # The pathname depends on OS: Unix, Windows, etc.
  # Pathname library works with pathnames of local OS.
  # However non-Unix pathnames are supported experimentally.
  #
  # It does not represent the file itself.
  # A Pathname can be relative or absolute.  It's not until you try to
  # reference the file that it even matters whether the file exists or not.
  #
  # Pathname is immutable.  It has no method for destructive update.
  #
  # The value of this class is to manipulate file path information in a neater
  # way than standard Ruby provides.  The examples below demonstrate the
  # difference.  *All* functionality from File, FileTest, and some from Dir and
  # FileUtils is included, in an unsurprising way.  It is essentially a facade for
  # all of these, and more.
  #
  # == Examples
  #
  # === Example 1: Using Pathname
  #
  #   require 'pathname'
  #   pn = Pathname.new("/usr/bin/ruby")
  #   size = pn.size              # 27662
  #   isdir = pn.directory?       # false
  #   dir  = pn.dirname           # Pathname:/usr/bin
  #   base = pn.basename          # Pathname:ruby
  #   dir, base = pn.split        # [Pathname:/usr/bin, Pathname:ruby]
  #   data = pn.read
  #   pn.open { |f| _ }
  #   pn.each_line { |line| _ }
  #
  # === Example 2: Using standard Ruby
  #
  #   pn = "/usr/bin/ruby"
  #   size = File.size(pn)        # 27662
  #   isdir = File.directory?(pn) # false
  #   dir  = File.dirname(pn)     # "/usr/bin"
  #   base = File.basename(pn)    # "ruby"
  #   dir, base = File.split(pn)  # ["/usr/bin", "ruby"]
  #   data = File.read(pn)
  #   File.open(pn) { |f| _ }
  #   File.foreach(pn) { |line| _ }
  #
  # === Example 3: Special features
  #
  #   p1 = Pathname.new("/usr/lib")   # Pathname:/usr/lib
  #   p2 = p1 + "ruby/1.8"            # Pathname:/usr/lib/ruby/1.8
  #   p3 = p1.parent                  # Pathname:/usr
  #   p4 = p2.relative_path_from(p3)  # Pathname:lib/ruby/1.8
  #   pwd = Pathname.pwd              # Pathname:/home/gavin
  #   pwd.absolute?                   # true
  #   p5 = Pathname.new "."           # Pathname:.
  #   p5 = p5 + "music/../articles"   # Pathname:music/../articles
  #   p5.cleanpath                    # Pathname:articles
  #   p5.realpath                     # Pathname:/home/gavin/articles
  #   p5.children                     # [Pathname:/home/gavin/articles/linux, ...]
  #
  # == Breakdown of functionality
  #
  # === Core methods
  #
  # These methods are effectively manipulating a String, because that's
  # all a path is.  Except for #mountpoint?, #children, #each_child,
  # #realdirpath and #realpath, they don't access the filesystem.
  #
  # - +
  # - #join
  # - #parent
  # - #root?
  # - #absolute?
  # - #relative?
  # - #relative_path_from
  # - #each_filename
  # - #cleanpath
  # - #realpath
  # - #realdirpath
  # - #children
  # - #each_child
  # - #mountpoint?
  #
  # === File status predicate methods
  #
  # These methods are a facade for FileTest:
  # - #blockdev?
  # - #chardev?
  # - #directory?
  # - #executable?
  # - #executable_real?
  # - #exist?
  # - #file?
  # - #grpowned?
  # - #owned?
  # - #pipe?
  # - #readable?
  # - #world_readable?
  # - #readable_real?
  # - #setgid?
  # - #setuid?
  # - #size
  # - #size?
  # - #socket?
  # - #sticky?
  # - #symlink?
  # - #writable?
  # - #world_writable?
  # - #writable_real?
  # - #zero?
  #
  # === File property and manipulation methods
  #
  # These methods are a facade for Wukong::Fs::WuFile:
  #
  # * #atime
  # * #ctime
  # * #mtime
  # * #chmod(mode)
  # * #lchmod(mode)
  # * #chown(owner, group)
  # * #lchown(owner, group)
  # * #fnmatch(pattern, *args)
  # * #fnmatch?(pattern, *args)
  # * #ftype
  # * #make_link(old)
  # * #open(*args, &block)
  # * #readlink
  # * #rename(to)
  # * #stat
  # * #lstat
  # * #make_symlink(old)
  # * #truncate(length)
  # * #utime(atime, mtime)
  # * #basename(*args)
  # * #dirname
  # * #extname
  # * #expand_path(*args)
  # * #split
  #
  # === Directory methods
  #
  # These methods are a facade for Dir:
  # * Pathname.glob(*args)
  # * Pathname.getwd / Pathname.pwd
  # * #rmdir
  # * #entries
  # * #each_entry(&block)
  # * #mkdir(*args)
  # * #opendir(*args)
  #
  # === IO
  #
  # These methods are a facade for IO:
  # * #each_line(*args, &block)
  # * #read(*args)
  # * #binread(*args)
  # * #readlines(*args)
  # * #sysopen(*args)
  #
  # === Utilities
  #
  # These methods are a mixture of Find, FileUtils, and others:
  # * #find(&block)
  # * #mkpath
  # * #rmtree
  # * #unlink / #delete
  #
  #
  # == Method documentation
  #
  # As the above section shows, most of the methods in Pathname are facades.  The
  # documentation for these methods generally just says, for instance, "See
  # FileTest.writable?", as you should be familiar with the original method
  # anyway, and its documentation (e.g. through +ri+) will contain more
  # information.  In some cases, a brief description will follow.
  #
  class WuPathname < Pathname
    attr_accessor :strpath

    #
    #
    # Create a Pathname object from the given String (or String-like object).
    # If +path+ contains a NUL character (`\0`), an ArgumentError is raised.
    #
    def initialize(arg)
    end

    def freeze
    end

    def taint
    end


    def untaint
    end

    #
    #
    #  Compare this pathname with +other+.  The comparison is string-based.
    #  Be aware that two different paths (`foo.txt` and `./foo.txt`)
    #  can refer to the same file.
    #
    def eq(other)
    end

    #
    #
    #  Provides for comparing pathnames, case-sensitively.
    #
    def cmp(other)
    end

    #
    #  :nodoc:
    #
    def hash
    end

    #
    #
    #  call-seq:
    #    pathname.to_s             -> string
    #    pathname.to_path          -> string
    #
    #  Return the path as a String.
    #
    #  to_path is implemented so Pathname objects are usable with File.open, etc.
    #
    def to_s
    end

    #
    #  :nodoc:
    #
    def inspect
    end

    #
    #
    # Return a pathname which is substituted by String#sub.
    #
    def sub(*args)
      to_s.sub(*args)
    end

    #
    #
    # Return a pathname which the extension of the basename is substituted by
    # <i>repl</i>.
    #
    # If self has no extension part, <i>repl</i> is appended.
    #
    def sub_ext(repl)
    end

    #
    #  Facade for File

    # Returns the real (absolute) pathname of +self+ in the actual
    # filesystem not containing symlinks or useless dots.
    #
    # All components of the pathname must exist when this method is
    # called.
    #
    #
    def realpath(*args)
    end

    #
    #
    # Returns the real (absolute) pathname of +self+ in the actual filesystem.
    # The real pathname doesn't contain symlinks or useless dots.
    #
    # The last component of the real pathname can be nonexistent.
    #
    def realdirpath(*args)
    end

    #
    #
    # call-seq:
    #   pathname.each_line {|line| ... }
    #   pathname.each_line(sep=$/ [, open_args]) {|line| block }     -> nil
    #   pathname.each_line(limit [, open_args]) {|line| block }      -> nil
    #   pathname.each_line(sep, limit [, open_args]) {|line| block } -> nil
    #   pathname.each_line(...)                                      -> an_enumerator
    #
    # #each_line iterates over the line in the file.  It yields a String object
    # for each line.
    #
    # This method is availabel since 1.8.1.
    #
    def each_line(*args)
    end

    #
    #
    # call-seq:
    #   pathname.read([length [, offset]]) -> string
    #   pathname.read([length [, offset]], open_args) -> string
    #
    # See `IO.read`.  Returns all data from the file, or the first +N+ bytes
    # if specified.
    #
    #
    def read(*args)
    end

    #
    #
    # call-seq:
    #   pathname.binread([length [, offset]]) -> string
    #
    # See `IO.binread`.  Returns all the bytes from the file, or the first +N+
    # if specified.
    #
    #
    def binread(*args)
    end

    #
    #
    # call-seq:
    #   pathname.readlines(sep=$/ [, open_args])     -> array
    #   pathname.readlines(limit [, open_args])      -> array
    #   pathname.readlines(sep, limit [, open_args]) -> array
    #
    # See `IO.readlines`.  Returns all the lines from the file.
    #
    #
    def readlines(*args)
    end

    #
    #
    # call-seq:
    #   pathname.sysopen([mode, [perm]])  -> fixnum
    #
    # See `IO.sysopen`.
    #
    #
    def sysopen(*args)
    end

    #
    #
    # See `File.atime`.  Returns last access time.
    #
    def atime
    end

    #
    #
    # See `File.ctime`.  Returns last (directory entry, not file) change time.
    #
    def ctime
    end

    #
    #
    # See `File.mtime`.  Returns last modification time.
    #
    def mtime
    end

    #
    #
    # See `File.chmod`.  Changes permissions.
    #
    def chmod(mode)
    end

    #
    #
    # See `File.lchmod`.
    #
    def lchmod(mode)
    end

    #
    #
    # See `File.chown`.  Change owner and group of file.
    #
    def chown(owner, group)
    end

    #
    #
    # See `File.lchown`.
    #
    def lchown(owner, group)
    end

    #
    #
    # call-seq:
    #    pathname.fnmatch(pattern, [flags])        -> string
    #    pathname.fnmatch?(pattern, [flags])       -> string
    #
    # See `File.fnmatch`.  Return +true+ if the receiver matches the given
    # pattern.
    #
    def fnmatch(*args)
    end

    #
    #
    # See `File.ftype`.  Returns "type" of file ("file", "directory",
    # etc).
    #
    def ftype
    end

    #
    #
    # call-seq:
    #   pathname.make_link(old)
    #
    # See `File.link`.  Creates a hard link at _pathname_.
    #
    def make_link(old)
    end

    #
    #
    # See `File.open`.  Opens the file for reading or writing.
    #
    def open(*args)
    end

    #
    #
    # See `File.readlink`.  Read symbolic link.
    #
    def readlink
    end

    #
    #
    # See `File.rename`.  Rename the file.
    #
    def rename(to)
    end

    #
    #
    # See `File.stat`.  Returns a `File::Stat` object.
    #
    def stat
    end

    #
    #
    # See `File.lstat`.
    #
    def lstat
    end

    #
    #
    # call-seq:
    #   pathname.make_symlink(old)
    #
    # See `File.symlink`.  Creates a symbolic link.
    #
    def make_symlink(old)
    end

    #
    #
    # See `File.truncate`.  Truncate the file to +length+ bytes.
    #
    def truncate(length)
    end

    #
    #
    # See `File.utime`.  Update the access and modification times.
    #
    def utime(atime, mtime)
    end

    #
    #
    # See `File.basename`.  Returns the last component of the path.
    #
    def basename(*args)
    end

    #
    #
    # See `File.dirname`.  Returns all but the last component of the path.
    #
    def dirname
    end

    #
    #
    # See `File.extname`.  Returns the file's extension.
    #
    def extname
    end

    #
    #
    # See `File.expand_path`.
    #
    def expand_path(*args)
    end

    #
    #
    # See `File.split`.  Returns the #dirname and the #basename in an Array.
    #
    def split
    end

    #
    #
    # See `FileTest.blockdev?`.
    #
    def blockdev?
    end

    #
    #
    # See `FileTest.chardev?`.
    #
    def chardev?
    end

    #
    #
    # See `FileTest.executable?`.
    #
    def executable?
    end

    #
    #
    # See `FileTest.executable_real?`.
    #
    def executable_real?
    end

    #
    #
    # See `FileTest.exist?`.
    #
    def exist?
    end

    #
    #
    # See `FileTest.grpowned?`.
    #
    def grpowned?
    end

    #
    #
    # See `FileTest.directory?`.
    #
    def directory?
    end

    #
    #
    # See `FileTest.file?`.
    #
    def file?
    end

    #
    #
    # See `FileTest.pipe?`.
    #
    def pipe?
    end

    #
    #
    # See `FileTest.socket?`.
    #
    def socket?
    end

    #
    #
    # See `FileTest.owned?`.
    #
    def owned?
    end

    #
    #
    # See `FileTest.readable?`.
    #
    def readable?
    end

    #
    #
    # See `FileTest.world_readable?`.
    #
    def world_readable?
    end

    #
    #
    # See `FileTest.readable_real?`.
    #
    def readable_real?
    end

    #
    #
    # See `FileTest.setuid?`.
    #
    def setuid?
    end

    #
    #
    # See `FileTest.setgid?`.
    #
    def setgid?
    end

    #
    #
    # See `FileTest.size`.
    #
    def size
    end

    #
    #
    # See `FileTest.size?`.
    #
    def size?
    end

    #
    #
    # See `FileTest.sticky?`.
    #
    def sticky?
    end

    #
    #
    # See `FileTest.symlink?`.
    #
    def symlink?
    end

    #
    #
    # See `FileTest.writable?`.
    #
    def writable?
    end

    #
    #
    # See `FileTest.world_writable?`.
    #
    def world_writable?
    end

    #
    #
    # See `FileTest.writable_real?`.
    #
    def writable_real?
    end

    #
    #
    # See `FileTest.zero?`.
    #
    def zero?
    end

    # * FNM_NOESCAPE 0x01 -- don't treat a `\` (backslash) character as special
    # * FNM_PATHNAME 0x02 -- If the FNM_PATHNAME flag is set in flags, then a slash character ( '/' ) in string shall be explicitly matched by a slash in pattern; it shall not be matched by either the asterisk or question-mark special characters, nor by a bracket expression. Basically: with this you have to match the whole path, not a segment of it.
    # * FNM_DOTMATCH 0x04 -- do match path segments that have a leading `.` (dot) character; otherwise they are ignored as "hidden" files
    # * FNM_CASEFOLD 0x08 -- case-insensitive match
    # * FNM_SYSCASE  FNM_CASEFOLD or 0 depending on system -- match according to operating system's typical case-sensitivity
    #
    # To use these, union them with the `|` (pipe) logical OR operator:
    #
    # ```ruby
    #     File.fnmatch('*/.*',    '/Users/flip/.profile') #=> true
    #     File.fnmatch('*/.*',    '/Users/flip/.profile', File::FNM_PATHNAME) #=> false
    #     File.fnmatch('/*/*/.*', '/Users/flip/.profile', File::FNM_PATHNAME) #=> true
    #     File.fnmatch('/*/*/*',  '/Users/flip/.profile', File::FNM_PATHNAME) #=> false
    #     File.fnmatch('/*/*/*',  '/Users/flip/.profile', File::FNM_PATHNAME | File::FNM_DOTMATCH) #=> true
    #     File.fnmatch('*/*',     '/Users/flip/.profile') #=> true (without FNM_PATHNAME, fnmatch doesn't care about . dots)
    #     File.fnmatch('/*/*/*',  '/Users/flip/.profile') #=> true
    # ```
    #
    # see [File.fnmatch] for moreexamples.

    def glob(pattern, flags=0, &block)
    end

    module ClassMethods

      #
      #
      # See `Dir.glob`.  Returns or yields Pathname objects.
      #
      def glob(int argc, *argv, klass)
      end

      #
      #
      # See `Dir.getwd`.  Returns the current working directory as a Pathname.
      #
      def getwd(klass)
      end

    end

    #
    #
    # Return the entries (files and subdirectories) in the directory, each as a
    # Pathname object.
    #
    # The result contains just a filename which has no directory.
    #
    # The result may contain the current directory #<Pathname:.> and the parent
    # directory #<Pathname:..>.
    #
    # If you don't want #<Pathname:.> and #<Pathname:..> and
    # want directory, consider Pathname#children.
    #
    #   pp Pathname.new('/usr/local').entries
    #   #=> [#<Pathname:share>,
    #   #    #<Pathname:lib>,
    #   #    #<Pathname:..>,
    #   #    #<Pathname:include>,
    #   #    #<Pathname:etc>,
    #   #    #<Pathname:bin>,
    #   #    #<Pathname:man>,
    #   #    #<Pathname:games>,
    #   #    #<Pathname:.>,
    #   #    #<Pathname:sbin>,
    #   #    #<Pathname:src>]
    #
    #
    def entries
    end

    #
    #
    # See `Dir.mkdir`.  Create the referenced directory.
    #
    def mkdir(*args)
    end

    #
    #
    # See `Dir.rmdir`.  Remove the referenced directory.
    #
    def rmdir
    end

    #
    #
    # See `Dir.open`.
    #
    def opendir
    end

    def each_entry
    end

    #
    #
    # Iterates over the entries (files and subdirectories) in the directory.  It
    # yields a Pathname object for each entry.
    #
    # This method has available since 1.8.1.
    #
    def each_entry
    end

    def unlink_body(str)
    end

    def unlink_rescue(str, errinfo)
    end

    #
    #
    # Removes a file or directory, using `File.unlink` or
    # `Dir.unlink` as necessary.
    #
    def unlink
    end
  end
end
