#
# A `File` is an abstraction of any file object accessible by the program and is
# closely associated with class `IO`
#
# `File` includes the methods of module `FileTest` as class methods, allowing
# you to write (for example) `File.exist?("foo")`.
#
# In the description of File methods, "permission bits" are a platform-specific
# set of bits that indicate permissions of a file. On Unix-based systems,
# permissions are viewed as a set of three octets, for the owner, the group, and
# the rest of the world. For each of these entities, permissions may be set to
# read, write, or execute the file:
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
# class WuFile
# 
# self << class

# Returns the pathname used to create *file* as a string. Does
# not normalize the name.
#
# @returns [String] filename
#
# @example
#    File.new("testfile").path               #=> "testfile"
#    File.new("/tmp/../tmp/xxx", "w").path   #=> "/tmp/../tmp/xxx"
#
def file.path
  stat.path
end

#
# Changes permission bits on *file* to the bit pattern represented by
# *mode_int*. Actual effects are platform dependent; on Unix systems, see
# `chmod(2)` for details.  Follows symbolic links. Also see `File#lchmod`.
#
# @example `file.chmod(mode_int) -> 0`
#    f = File.new("out", "w");
#    f.chmod(0644)   #=> 0
#
def file.chmod(mode_int)
  NoMethodError.abstract(self)
end

#
# Changes the owner and group of *file* to the given numeric owner and group
# id's. Only a process with superuser privileges may change the owner of a
# file. The current owner of a file may change the file's group to any group to
# which the owner belongs. A `nil` or -1 owner or group id is ignored. Follows
# symbolic links. See also `File#lchown`.
#
# @example `file.chown(owner_id, group_id) -> 0`
#    File.new("testfile").chown(502, 1000)
#
def file.chown(owner_id, group_id)
  NoMethodError.abstract(self)
end

#
# Equivalent to `File::chown`, but does not follow symbolic links (so it will
# change the owner associated with the link, not the file referenced by the
# link). Often not available. Returns number of files in the argument list.
#
# @example `file.lchown(owner_id, group_id, *filenames) -> integer`
#    File.new("testfile").chown(502, 1000)
#
def file.lchown(owner_id, group_id, *filenames)
  NoMethodError.abstract(self)
end

#
# Truncates *file* to at most *integer* bytes. The file must be opened for
# writing. Not available on all platforms.
#
# @example `file.truncate(integer) -> 0`
#    f = File.new("out", "w")
#    f.syswrite("1234567890")   #=> 10
#    f.truncate(5)              #=> 0
#    f.close()                  #=> nil
#    File.size("out")           #=> 5
#
def file.truncate(integer)
  NoMethodError.abstract(self)
end

# --------------------------------------------------------------------------

#
# Returns status information for "ios" as an object of type `File::Stat`.
#
# @example `ios.stat -> stat`
#    f = File.new("testfile")
#    s = f.stat
#    "%o" % s.mode   #=> "100644"
#    s.blksize       #=> 4096
#    s.atime         #=> Wed Apr 09 08:53:54 CDT 2003
#
def ios.stat
  NoMethodError.abstract(self)
end

#
# Returns the last access time (a `Time` object) for *file*, or epoch if *file*
# has not been accessed.
#
# @example `file.atime -> time`
#    File.new("testfile").atime   #=> Wed Dec 31 18:00:00 CST 1969
#
def file.atime
  stat.atime
end

#
# Returns the modification time for *file*.
#
# @example `file.mtime -> time`
#    File.new("testfile").mtime   #=> Wed Apr 09 08:53:14 CDT 2003
#
def file.mtime
  NoMethodError.abstract(self)
end

#
# Returns the change time for *file* (that is, the time directory
# information about the file was changed, not the file itself).
#
# Note that on Windows (NTFS), returns creation time (birth time).
#
# @example `file.ctime -> time`
#    File.new("testfile").ctime   #=> Wed Apr 09 08:53:14 CDT 2003
#
def file.ctime
  NoMethodError.abstract(self)
end

#
# Returns the size of *file* in bytes.
#
# @example `file.size -> integer`
#    File.new("testfile").size   #=> 66
#
def file.size
  NoMethodError.abstract(self)
end

# --------------------------------------------------------------------------

#
# call-seq:
#   test(int_cmd,file1 [, file2] ) -> obj
#
# Uses the integer +int_cmd+ to perform various tests on +file1+ (first table
# below) or on +file1+ and +file2+ (second table).
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
#   "g"  | boolean | True if file1 has the \CF{setgid} bit set (false under NT)
#   "G"  | boolean | True if file1 exists and has a group ownership equal to the caller's group
#   "k"  | boolean | True if file1 exists and has the sticky bit set
#   "l"  | boolean | True if file1 exists and is a symbolic link
#   "M"  | Time    | Last modification time for file1
#   "o"  | boolean | True if file1 exists and is owned by the caller's effective uid
#   "O"  | boolean | True if file1 exists and is owned by the caller's real uid
#   "p"  | boolean | True if file1 exists and is a fifo
#   "r"  | boolean | True if file1 is readable by the effective uid/gid of the caller
#   "R"  | boolean | True if file is readable by the real uid/gid of the caller
#   "s"  | int/nil | If file1 has nonzero size, return the size, otherwise return nil
#   "S"  | boolean | True if file1 exists and is a socket
#   "u"  | boolean | True if file1 has the setuid bit set
#   "w"  | boolean | True if file1 exists and is writable by the effective uid/gid
#   "W"  | boolean | True if file1 exists and is writable by the real uid/gid
#   "x"  | boolean | True if file1 exists and is executable by the effective uid/gid
#   "X"  | boolean | True if file1 exists and is executable by the real uid/gid
#   "z"  | boolean | True if file1 exists and has a zero length
#
# Tests that take two files:
#
#   "-"  | boolean | True if file1 and file2 are identical
#   "="  | boolean | True if the modification times of file1 and file2 are equal
#   "<"  | boolean | True if the modification time of file1 is prior to that of file2
#   ">"  | boolean | True if the modification time of file1 is after that of file2
#
def test(int_cmd, *filenames)
  NoMethodError.abstract(self)
end
