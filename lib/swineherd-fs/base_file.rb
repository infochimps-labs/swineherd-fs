#
# A `File` is an abstraction of any file object accessible by the program and is
# closely associated with class `IO`
#
# `File` includes the methods of module `FileTest` as class methods, allowing
# you to write (for example) `File.exist?("foo")`.
#
# In the description of File methods, "permission bits" are a
# platform-specific set of bits that indicate permissions of a file. On
# Unix-based systems, permissions are viewed as a set of three octets, for the
# owner, the group, and the rest of the world. For each of these entities,
# permissions may be set to read, write, or execute the file:
#
# The permission bits `0644` (in octal) would thus be interpreted as read/write
# for owner, and read-only for group and other. Higher-order bits may also be
# used to indicate the type of file (plain, directory, pipe, socket, and so on)
# and various other special features. If the permissions are for a directory,
# the meaning of the execute bit changes; when set the directory can be
# searched.
#
# On non-Posix operating systems, there may be only the ability to make a file
# read-only or read-write. In this case, the remaining permission bits will be
# synthesized to resemble typical values. For instance, on Windows NT the
# default permission bits are `0644`, which means read/write for owner,
# read-only for all others. The only change that can be made is to make the file
# read-only, which is reported as `0444`.
#

#
# call-seq:
#   file.path ->  filename
#
# Returns the pathname used to create *file* as a string. Does
# not normalize the name.
#
#    File.new("testfile").path               #=> "testfile"
#    File.new("/tmp/../tmp/xxx", "w").path   #=> "/tmp/../tmp/xxx"
#
def file.path()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.size(file_name)  -> integer
#
#Returns the size of `file_name`.
#
def File.size(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.ftype(file_name)  -> string
#
# Identifies the type of the named file; the return string is one of
# ```file`'', ```directory`'',
# ```characterSpecial`'', ```blockSpecial`'',
# ```fifo`'', ```link`'',
# ```socket`'', or ```unknown`''.
#
#    File.ftype("testfile")            #=> "file"
#    File.ftype("/dev/tty")            #=> "characterSpecial"
#    File.ftype("/tmp/.X11-unix/X0")   #=> "socket"
#
def File.ftype(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.atime(file_name) ->  time
#
# Returns the last access time for the named file as a Time object).
#
#    File.atime("testfile")   #=> Wed Apr 09 08:51:48 CDT 2003
#
#
def File.atime(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.atime   -> time
#
# Returns the last access time (a `Time` object)
#  for *file*, or epoch if *file* has not been accessed.
#
#    File.new("testfile").atime   #=> Wed Dec 31 18:00:00 CST 1969
#
#
def file.atime()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.mtime(file_name) ->  time
#
# Returns the modification time for the named file as a Time object.
#
#    File.mtime("testfile")   #=> Tue Apr 08 12:58:04 CDT 2003
#
#
def File.mtime(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.mtime ->  time
#
# Returns the modification time for *file*.
#
#    File.new("testfile").mtime   #=> Wed Apr 09 08:53:14 CDT 2003
#
#
def file.mtime()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.ctime(file_name) -> time
#
# Returns the change time for the named file (the time at which
# directory information about the file was changed, not the file
# itself).
#
# Note that on Windows (NTFS), returns creation time (birth time).
#
#    File.ctime("testfile")   #=> Wed Apr 09 08:53:13 CDT 2003
#
#
def File.ctime(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.ctime ->  time
#
# Returns the change time for *file* (that is, the time directory
# information about the file was changed, not the file itself).
#
# Note that on Windows (NTFS), returns creation time (birth time).
#
#    File.new("testfile").ctime   #=> Wed Apr 09 08:53:14 CDT 2003
#
#
def file.ctime()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.size   -> integer
#
# Returns the size of *file* in bytes.
#
#    File.new("testfile").size   #=> 66
#
#
def file.size()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.chmod(mode_int,file_name, ... )  ->  integer
#
# Changes permission bits on the named file(s) to the bit pattern
# represented by *mode_int*. Actual effects are operating system
# dependent (see the beginning of this section). On Unix systems, see
# `chmod(2)` for details. Returns the number of files
# processed.
#
#    File.chmod(0644, "testfile", "out")   #=> 2
#
def File.chmod(mode_int,file_name, *args)
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.chmod(mode_int)  -> 0
#
# Changes permission bits on *file* to the bit pattern
# represented by *mode_int*. Actual effects are platform
# dependent; on Unix systems, see `chmod(2)` for details.
# Follows symbolic links. Also see `File#lchmod`.
#
#    f = File.new("out", "w");
#    f.chmod(0644)   #=> 0
#
def file.chmod(mode_int)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.lchmod(mode_int,file_name, ...)  -> integer
#
# Equivalent to `File::chmod`, but does not follow symbolic
# links (so it will change the permissions associated with the link,
# not the file referenced by the link). Often not available.
#
#
def File.lchmod(mode_int,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.chown(owner_int,group_int, file_name,... )  ->  integer
#
# Changes the owner and group of the named file(s) to the given
# numeric owner and group id's. Only a process with superuser
# privileges may change the owner of a file. The current owner of a
# file may change the file's group to any group to which the owner
# belongs. A `nil` or -1 owner or group id is ignored.
# Returns the number of files processed.
#
#    File.chown(nil, 100, "testfile")
#
#
def File.chown(owner_int,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.chown(owner_int,group_int )   -> 0
#
# Changes the owner and group of *file* to the given numeric
# owner and group id's. Only a process with superuser privileges may
# change the owner of a file. The current owner of a file may change
# the file's group to any group to which the owner belongs. A
# `nil` or -1 owner or group id is ignored. Follows
# symbolic links. See also `File#lchown`.
#
#    File.new("testfile").chown(502, 1000)
#
#
def file.chown(owner_int,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.lchown(owner_int,group_int, file_name,..) -> integer
#
# Equivalent to `File::chown`, but does not follow symbolic
# links (so it will change the owner associated with the link, not the
# file referenced by the link). Often not available. Returns number
# of files in the argument list.
#
#
def file.lchown(owner_int,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.utime(atime,mtime, file_name,...)   ->  integer
#
#Sets the access and modification times of each
#named file to the first two arguments. Returns
#the number of file names in the argument list.
#
def File.utime(atime,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.link(old_name,new_name)    -> 0
#
# Creates a new name for an existing file using a hard link. Will not
# overwrite *new_name* if it already exists (raising a subclass
# of `SystemCallError`). Not available on all platforms.
#
#    File.link("testfile", ".testfile")   #=> 0
#    IO.readlines(".testfile")[0]         #=> "This is line one\n"
#
def File.link(old_name,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.symlink(old_name,new_name)   -> 0
#
# Creates a symbolic link called *new_name* for the existing file
# *old_name*. Raises a `NotImplemented` exception on
# platforms that do not support symbolic links.
#
#    File.symlink("testfile", "link2test")   #=> 0
#
#
def File.symlink(old_name,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.readlink(link_name) ->  file_name
#
# Returns the name of the file referenced by the given link.
# Not available on all platforms.
#
#    File.symlink("testfile", "link2test")   #=> 0
#    File.readlink("link2test")              #=> "testfile"
#
def File.readlink(link_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.delete(file_name,...)  -> integer
#    File.unlink(file_name, ...)  -> integer
#
# Deletes the named files, returning the number of names
# passed as arguments. Raises an exception on any error.
# See also `Dir::rmdir`.
#
def File.delete(file_name,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.rename(old_name,new_name)   -> 0
#
# Renames the given file to the new name. Raises a
# `SystemCallError` if the file cannot be renamed.
#
#    File.rename("afile", "afile.bak")   #=> 0
#
def File.rename(old_name,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.umask()         -> integer
#    File.umask(integer)   -> integer
#
# Returns the current umask value for this process. If the optional
# argument is given, set the umask to that value and return the
# previous value. Umask values are *subtracted* from the
# default permissions, so a umask of `0222` would make a
# file read-only for everyone.
#
#    File.umask(0006)   #=> 18
#    File.umask         #=> 6
#
def File.umask()()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.expand_path(file_name[, dir_string] )  ->  abs_file_name
#
# Converts a pathname to an absolute pathname. Relative paths are
# referenced from the current working directory of the process unless
# *dir_string* is given, in which case it will be used as the
# starting point. The given pathname may start with a
# ```~`'', which expands to the process owner's home
# directory (the environment variable `HOME` must be set
# correctly). ```~`*user*'' expands to the named
# user's home directory.
#
#    File.expand_path("~oracle/bin")           #=> "/home/oracle/bin"
#    File.expand_path("../../bin", "/tmp/x")   #=> "/bin"
#
def File.expand_path(file_name()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.absolute_path(file_name[, dir_string] )  ->  abs_file_name
#
# Converts a pathname to an absolute pathname. Relative paths are
# referenced from the current working directory of the process unless
# *dir_string* is given, in which case it will be used as the
# starting point. If the given pathname starts with a ```~`''
# it is NOT expanded, it is treated as a normal directory name.
#
#    File.absolute_path("~oracle/bin")       #=> "<relative_path>/~oracle/bin"
#
def File.absolute_path(file_name()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.realpath(pathname[, dir_string])  ->  real_pathname
#
# Returns the real (absolute) pathname of _pathname_ in the actual
# filesystem not containing symlinks or useless dots.
#
# If _dir_string_ is given, it is used as a base directory
# for interpreting relative pathname instead of the current directory.
#
# All components of the pathname must exist when this method is
# called.
#
def File.realpath(pathname()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.realdirpath(pathname[, dir_string])  ->  real_pathname
#
# Returns the real (absolute) pathname of _pathname_ in the actual filesystem.
# The real pathname doesn't contain symlinks or useless dots.
#
# If _dir_string_ is given, it is used as a base directory
# for interpreting relative pathname instead of the current directory.
#
# The last component of the real pathname can be nonexistent.
#
def File.realdirpath(pathname()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.basename(file_name[, suffix] )  ->  base_name
#
# Returns the last component of the filename given in *file_name*,
# which must be formed using forward slashes (```/`'')
# regardless of the separator used on the local file system. If
# *suffix* is given and present at the end of *file_name*,
# it is removed.
#
#    File.basename("/home/gumby/work/ruby.rb")          #=> "ruby.rb"
#    File.basename("/home/gumby/work/ruby.rb", ".rb")   #=> "ruby"
#
def File.basename(file_name()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.dirname(file_name)  ->  dir_name
#
# Returns all components of the filename given in *file_name*
# except the last one. The filename must be formed using forward
# slashes (```/`'') regardless of the separator used on the
# local file system.
#
#    File.dirname("/home/gumby/work/ruby.rb")   #=> "/home/gumby/work"
#
def File.dirname(file_name()
  NoMethodError.abstract(self)
end

#
#accept a String, and return the pointer of the extension.
#if len is passed, set the length of extension to it.
#returned pointer is in ``name'' or NULL.
#                returns   *len
#  no dot        NULL      0
#  dotfile       top       0
#  end with dot  dot       1
#  .ext          dot       len of .ext
#  .ext:stream   dot       len of .ext without :stream (NT only)
#
#
#
# call-seq:
#   File.extname(path) ->  string
#
# Returns the extension (the portion of file name in *path*
# after the period).
#
#    File.extname("test.rb")         #=> ".rb"
#    File.extname("a/b/d/test.rb")   #=> ".rb"
#    File.extname("test")            #=> ""
#    File.extname(".profile")        #=> ""
#
#
def File.extname(path)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.path(path) ->  string
#
# Returns the string representation of the path
#
#    File.path("/dev/null")          #=> "/dev/null"
#    File.path(Pathname.new("/tmp")) #=> "/tmp"
#
#
def File.path(path)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.split(file_name)  -> array
#
# Splits the given string into a directory and a file component and
# returns them in a two-element array. See also
# `File::dirname` and `File::basename`.
#
#    File.split("/home/gumby/.profile")   #=> ["/home/gumby", ".profile"]
#
def File.split(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.join(string,...)  ->  path
#
# Returns a new string formed by joining the strings using
# `File::SEPARATOR`.
#
#    File.join("usr", "mail", "gumby")   #=> "usr/mail/gumby"
#
#
def File.join(string,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.truncate(file_name,integer)  -> 0
#
# Truncates the file *file_name* to be at most *integer*
# bytes long. Not available on all platforms.
#
#    f = File.new("out", "w")
#    f.write("1234567890")     #=> 10
#    f.close                   #=> nil
#    File.truncate("out", 5)   #=> 0
#    File.size("out")          #=> 5
#
#
def File.truncate(file_name,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.truncate(integer)   -> 0
#
# Truncates *file* to at most *integer* bytes. The file
# must be opened for writing. Not available on all platforms.
#
#    f = File.new("out", "w")
#    f.syswrite("1234567890")   #=> 10
#    f.truncate(5)              #=> 0
#    f.close()                  #=> nil
#    File.size("out")           #=> 5
#
def file.truncate(integer)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.flock(locking_constant )-> 0 or false
#
# Locks or unlocks a file according to *locking_constant* (a
# logical "or" of the values in the table below).
# Returns `false` if `File::LOCK_NB` is
# specified and the operation would otherwise have blocked. Not
# available on all platforms.
#
# Locking constants (in class File):
#
#    LOCK_EX   | Exclusive lock. Only one process may hold an
#              | exclusive lock for a given file at a time.
#    ----------+------------------------------------------------
#    LOCK_NB   | Don't block when locking. May be combined
#              | with other lock options using logical or.
#    ----------+------------------------------------------------
#    LOCK_SH   | Shared lock. Multiple processes may each hold a
#              | shared lock for a given file at the same time.
#    ----------+------------------------------------------------
#    LOCK_UN   | Unlock.
#
# Example:
#
#    # update a counter using write lock
#    # don't use "w" because it truncates the file before lock.
#    File.open("counter", File::RDWR|File::CREAT, 0644) {|f|
#      f.flock(File::LOCK_EX)
#      value = f.read.to_i + 1
#      f.rewind
#      f.write("#{value}\n")
#      f.flush
#      f.truncate(f.pos)
#    }
#
#    # read the counter using read lock
#    File.open("counter", "r") {|f|
#      f.flock(File::LOCK_SH)
#      p f.read
#    }
#
#
def file.flock()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   test(int_cmd,file1 [, file2] ) -> obj
#
# Uses the integer +int_cmd+ to perform various tests on +file1+ (first
# table below) or on +file1+ and +file2+ (second table).
#
# File tests on a single file:
#
#   Test   Returns   Meaning
#   "A"  | Time    | Last access time for file1
#   "b"  | boolean | True if file1 is a block device
#   "c"  | boolean | True if file1 is a character device
#   "C"  | Time    | Last change time for file1
#   "d"  | boolean | True if file1 exists and is a directory
#   "e"  | boolean | True if file1 exists
#   "f"  | boolean | True if file1 exists and is a regular file
#   "g"  | boolean | True if file1 has the \CF{setgid} bit
#        |         | set (false under NT)
#   "G"  | boolean | True if file1 exists and has a group
#        |         | ownership equal to the caller's group
#   "k"  | boolean | True if file1 exists and has the sticky bit set
#   "l"  | boolean | True if file1 exists and is a symbolic link
#   "M"  | Time    | Last modification time for file1
#   "o"  | boolean | True if file1 exists and is owned by
#        |         | the caller's effective uid
#   "O"  | boolean | True if file1 exists and is owned by
#        |         | the caller's real uid
#   "p"  | boolean | True if file1 exists and is a fifo
#   "r"  | boolean | True if file1 is readable by the effective
#        |         | uid/gid of the caller
#   "R"  | boolean | True if file is readable by the real
#        |         | uid/gid of the caller
#   "s"  | int/nil | If file1 has nonzero size, return the size,
#        |         | otherwise return nil
#   "S"  | boolean | True if file1 exists and is a socket
#   "u"  | boolean | True if file1 has the setuid bit set
#   "w"  | boolean | True if file1 exists and is writable by
#        |         | the effective uid/gid
#   "W"  | boolean | True if file1 exists and is writable by
#        |         | the real uid/gid
#   "x"  | boolean | True if file1 exists and is executable by
#        |         | the effective uid/gid
#   "X"  | boolean | True if file1 exists and is executable by
#        |         | the real uid/gid
#   "z"  | boolean | True if file1 exists and has a zero length
#
# Tests that take two files:
#
#   "-"  | boolean | True if file1 and file2 are identical
#   "="  | boolean | True if the modification times of file1
#        |         | and file2 are equal
#   "<"  | boolean | True if the modification time of file1
#        |         | is prior to that of file2
#   ">"  | boolean | True if the modification time of file1
#        |         | is after that of file2
#
def test(int_cmd,()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   state.size   -> integer
#
# Returns the size of *stat* in bytes.
#
#    File.stat("testfile").size   #=> 66
#
#
def state.size()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.setuid?   -> true or false
#
# Returns `true` if *stat* has the set-user-id
# permission bit set, `false` if it doesn't or if the
# operating system doesn't support this feature.
#
#    File.stat("/bin/su").setuid?   #=> true
#
def stat.setuid?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.setgid?  -> true or false
#
# Returns `true` if *stat* has the set-group-id
# permission bit set, `false` if it doesn't or if the
# operating system doesn't support this feature.
#
#    File.stat("/usr/sbin/lpc").setgid?   #=> true
#
#
def stat.setgid?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.sticky?   -> true or false
#
# Returns `true` if *stat* has its sticky bit set,
# `false` if it doesn't or if the operating system doesn't
# support this feature.
#
#    File.stat("testfile").sticky?   #=> false
#
#
def stat.sticky?()
  NoMethodError.abstract(self)
end
