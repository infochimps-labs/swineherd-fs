# module Wukong
#   class WuFile

#
# Document-class: File::Stat
#
# Objects of class `File::Stat` encapsulate common status information for
# `File` objects. The information is recorded at the moment the `File::Stat`
# object is created; changes made to the file after that point will not be
# reflected. `File::Stat` objects are returned by `IO#stat`, `File::stat`,
# `File#lstat`, and `File::lstat`. Many of these methods return
# platform-specific values, and not all values are meaningful on all
# systems. See also `Kernel#test`.
#

# class Stat

# call-seq:
#
#   File::Stat.new(filename) -> stat
#
# Create a File::Stat object for the given file name (raising an exception if
# the file doesn't exist).

field  :ftype,   String, :doc => 'Identifies the type of the named file: one of "file", "directory", "characterSpecial", "blockSpecial", "fifo", "link", "socket", or "unknown"'
field  :mode,    String, :doc => 'an integer representing the permission bits of *stat*. The meaning of the bits is platform dependent; on Unix systems, see `stat(2)`.'
field  :size,    String, :doc => 'the size of *stat* in bytes.'
field  :blocks,  String, :doc => 'the number of native file system blocks allocated for this file, or `nil` if the operating system doesn\'t support this feature.'
field  :blksize, String, :doc => 'the native file system\'s block size. Will return `nil` on platforms that don\'t support this information.'
field  :atime,   String, :doc => 'the last access time for this file as an object of class `Time`.'
field  :ctime,   String, :doc => 'the change time for *stat* (that is, the time directory information about the file was changed, not the file itself). Note that on Windows (NTFS), returns creation time (birth time).'
field  :mtime,   String, :doc => 'the modification time of *stat*.'
field  :uid,     String, :doc => 'the numeric user id of the owner of *stat*.'
field  :gid,     String, :doc => 'the numeric group id of the owner of *stat*.'

#
# Compares `File::Stat` objects by comparing their respective modification
# times.
#
# @example `stat <=> other_stat -> -1, 0, 1, nil`
#    f1 = File.new("f1", "w")
#    sleep 1
#    f2 = File.new("f2", "w")
#    f1.stat <=> f2.stat   #=> -1
#
def <=>
    NoMethodError.abstract(self)
end

# Produce a nicely formatted description of *stat*.
#
# @example `stat.inspect -> string`
#   File.stat("/etc/passwd").inspect
#   #=> "#<File::Stat dev=0xe000005, ino=1078078, mode=0100644, nlink=1, uid=0,
#   #    gid=0, rdev=0x0, size=1374, blksize=4096, blocks=8, atime=Wed Dec 10
#   #    10:16:12 CST 2003, mtime=Fri Sep 12 15:41:41 CDT 2003, ctime=Mon Oct 27
#   #    11:20:27 CST 2003>"
#
def stat.inspect
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is a directory, `false` otherwise.
#
# @example `stat.directory? -> true or false`
#    File.stat("testfile").directory?   #=> false
#    File.stat(".").directory?          #=> true
#
def stat.directory?
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is a symbolic link, `false` if it isn't or if the
# operating system doesn't support this feature. As `File::stat` automatically
# follows symbolic links, `symlink?` will always be `false` for an object
# returned by `File::stat`.
#
# @example `stat.symlink? -> true or false`
#    File.symlink("testfile", "alink")   #=> 0
#    File.stat("alink").symlink?         #=> false
#    File.lstat("alink").symlink?        #=> true
#
def stat.symlink?
  NoMethodError.abstract(self)
end

#
# `true` if the effective user id of the process is the same as the
# owner of *stat*.
#
# @example `stat.owned? -> true or false`
#    File.stat("testfile").owned?      #=> true
#    File.stat("/etc/passwd").owned?   #=> false
#
def stat.owned?
  NoMethodError.abstract(self)
end

#
# true if the effective group id of the process is the same as the group
# id of *stat*. On Windows NT, returns `false`.
#
# @example `stat.grpowned? -> true or false`
#    File.stat("testfile").grpowned?      #=> true
#    File.stat("/etc/passwd").grpowned?   #=> false
#
def stat.grpowned?
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is readable by the effective user id of this process.
#
# @example `stat.readable? -> true or false`
#    File.stat("testfile").readable?   #=> true
#
def stat.readable?
  NoMethodError.abstract(self)
end

#
#If *stat* is readable by others, returns an integer representing the file
#permission bits of *stat*. Returns `nil` otherwise. The meaning of the bits is
#platform dependent; on Unix systems, see `stat(2)`.
#
# @example `stat.world_readable?-> fixnum or nil`
#   m = File.stat("/etc/passwd").world_readable?  #=> 420
#   sprintf("%o", m)                              #=> "644"
#
def stat.world_readable?
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is writable by the effective user id of this process.
#
# @example `stat.writable? -> true or false`
#    File.stat("testfile").writable?   #=> true
#
def stat.writable?
  NoMethodError.abstract(self)
end

#
# If *stat* is writable by others, returns an integer representing the file
# permission bits of *stat*. Returns `nil` otherwise. The meaning of the bits is
# platform dependent; on Unix systems, see `stat(2)`.
#
# @example `stat.world_writable? -> fixnum or nil`
#   m = File.stat("/tmp").world_writable?         #=> 511
#   sprintf("%o", m)                              #=> "777"
#
def stat.world_writable?
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is executable or if the operating system doesn't distinguish
# executable files from nonexecutable files. The tests are made using the
# effective owner of the process.
#
# @example `stat.executable? -> true or false`
#    File.stat("testfile").executable?   #=> false
#
def stat.executable?
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is a regular file (not a device file, pipe, socket,
# etc.).
#
# @example `stat.file? -> true or false`
#    File.stat("testfile").file?   #=> true
#
def stat.file?
  NoMethodError.abstract(self)
end

#
# `true` if *stat* is a zero-length file; `false` otherwise.
#
# @example `stat.zero? -> true or false`
#    File.stat("testfile").zero?   #=> false
#
def stat.zero?
  NoMethodError.abstract(self)
end

# end
