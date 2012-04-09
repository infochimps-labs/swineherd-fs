module Wukong
  class WuFile

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
    class Stat

      # call-seq:
      #
      #   File::Stat.new(file_name)  -> stat
      #
      # Create a File::Stat object for the given file name (raising an
      # exception if the file doesn't exist).

#
# call-seq:
#   stat<=> other_stat    -> -1, 0, 1, nil
#
# Compares `File::Stat` objects by comparing their
# respective modification times.
#
#    f1 = File.new("f1", "w")
#    sleep 1
#    f2 = File.new("f2", "w")
#    f1.stat <=> f2.stat   #=> -1
#
def stat()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.dev   -> fixnum
#
# Returns an integer representing the device on which *stat*
# resides.
#
#    File.stat("testfile").dev   #=> 774
#
def stat.dev()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.dev_major  -> fixnum
#
# Returns the major part of `File_Stat#dev` or
# `nil`.
#
#    File.stat("/dev/fd1").dev_major   #=> 2
#    File.stat("/dev/tty").dev_major   #=> 5
#
def stat.dev_major()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.dev_minor  -> fixnum
#
# Returns the minor part of `File_Stat#dev` or
# `nil`.
#
#    File.stat("/dev/fd1").dev_minor   #=> 1
#    File.stat("/dev/tty").dev_minor   #=> 0
#
def stat.dev_minor()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.ino  -> fixnum
#
# Returns the inode number for *stat*.
#
#    File.stat("testfile").ino   #=> 1083669
#
#
def stat.ino()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.mode  -> fixnum
#
# Returns an integer representing the permission bits of
# *stat*. The meaning of the bits is platform dependent; on
# Unix systems, see `stat(2)`.
#
#    File.chmod(0644, "testfile")   #=> 1
#    s = File.stat("testfile")
#    sprintf("%o", s.mode)          #=> "100644"
#
def stat.mode()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.nlink  -> fixnum
#
# Returns the number of hard links to *stat*.
#
#    File.stat("testfile").nlink             #=> 1
#    File.link("testfile", "testfile.bak")   #=> 0
#    File.stat("testfile").nlink             #=> 2
#
#
def stat.nlink()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.uid   -> fixnum
#
# Returns the numeric user id of the owner of *stat*.
#
#    File.stat("testfile").uid   #=> 501
#
#
def stat.uid()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.gid  -> fixnum
#
# Returns the numeric group id of the owner of *stat*.
#
#    File.stat("testfile").gid   #=> 500
#
#
def stat.gid()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.rdev  ->  fixnum or nil
#
# Returns an integer representing the device type on which
# *stat* resides. Returns `nil` if the operating
# system doesn't support this feature.
#
#    File.stat("/dev/fd1").rdev   #=> 513
#    File.stat("/dev/tty").rdev   #=> 1280
#
def stat.rdev()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.rdev_major  -> fixnum
#
# Returns the major part of `File_Stat#rdev` or
# `nil`.
#
#    File.stat("/dev/fd1").rdev_major   #=> 2
#    File.stat("/dev/tty").rdev_major   #=> 5
#
def stat.rdev_major()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.rdev_minor  -> fixnum
#
# Returns the minor part of `File_Stat#rdev` or
# `nil`.
#
#    File.stat("/dev/fd1").rdev_minor   #=> 1
#    File.stat("/dev/tty").rdev_minor   #=> 0
#
def stat.rdev_minor()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.size   -> fixnum
#
# Returns the size of *stat* in bytes.
#
#    File.stat("testfile").size   #=> 66
#
def stat.size()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.blksize  -> integer or nil
#
# Returns the native file system's block size. Will return `nil`
# on platforms that don't support this information.
#
#    File.stat("testfile").blksize   #=> 4096
#
#
def stat.blksize()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.blocks   -> integer or nil
#
# Returns the number of native file system blocks allocated for this
# file, or `nil` if the operating system doesn't
# support this feature.
#
#    File.stat("testfile").blocks   #=> 2
#
def stat.blocks()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.atime  -> time
#
# Returns the last access time for this file as an object of class
# `Time`.
#
#    File.stat("testfile").atime   #=> Wed Dec 31 18:00:00 CST 1969
#
#
def stat.atime()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.mtime ->  aTime
#
# Returns the modification time of *stat*.
#
#    File.stat("testfile").mtime   #=> Wed Apr 09 08:53:14 CDT 2003
#
#
def stat.mtime()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.ctime ->  aTime
#
# Returns the change time for *stat* (that is, the time
# directory information about the file was changed, not the file
# itself).
#
# Note that on Windows (NTFS), returns creation time (birth time).
#
#    File.stat("testfile").ctime   #=> Wed Apr 09 08:53:14 CDT 2003
#
#
def stat.ctime()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.inspect ->  string
#
#Produce a nicely formatted description of *stat*.
#
#  File.stat("/etc/passwd").inspect
#     #=> "#<File::Stat dev=0xe000005, ino=1078078, mode=0100644,
#     #    nlink=1, uid=0, gid=0, rdev=0x0, size=1374, blksize=4096,
#     #    blocks=8, atime=Wed Dec 10 10:16:12 CST 2003,
#     #    mtime=Fri Sep 12 15:41:41 CDT 2003,
#     #    ctime=Mon Oct 27 11:20:27 CST 2003>"
#
def stat.inspect()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.stat(file_name)  ->  stat
#
# Returns a `File::Stat` object for the named file (see
# `File::Stat`).
#
#    File.stat("testfile").mtime   #=> Tue Apr 08 12:58:04 CDT 2003
#
#
def File.stat(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   ios.stat   -> stat
#
# Returns status information for "ios" as an object of type
# `File::Stat`.
#
#    f = File.new("testfile")
#    s = f.stat
#    "%o" % s.mode   #=> "100644"
#    s.blksize       #=> 4096
#    s.atime         #=> Wed Apr 09 08:53:54 CDT 2003
#
#
def ios.stat()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.lstat(file_name)  -> stat
#
# Same as `File::stat`, but does not follow the last symbolic
# link. Instead, reports on the link itself.
#
#    File.symlink("testfile", "link2test")   #=> 0
#    File.stat("testfile").size              #=> 66
#    File.lstat("link2test").size            #=> 8
#    File.stat("link2test").size             #=> 66
#
#
def File.lstat(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   file.lstat  ->  stat
#
# Same as `IO#stat`, but does not follow the last symbolic
# link. Instead, reports on the link itself.
#
#    File.symlink("testfile", "link2test")   #=> 0
#    File.stat("testfile").size              #=> 66
#    f = File.new("link2test")
#    f.lstat.size                            #=> 8
#    f.stat.size                             #=> 66
#
def file.lstat()
  NoMethodError.abstract(self)
end


#
# call-seq:
#   stat.ftype  -> string
#
# Identifies the type of *stat*. The return string is one of:
# ```file`'', ```directory`'',
# ```characterSpecial`'', ```blockSpecial`'',
# ```fifo`'', ```link`'',
# ```socket`'', or ```unknown`''.
#
#    File.stat("/dev/tty").ftype   #=> "characterSpecial"
#
#
def stat.ftype()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.directory?  -> true or false
#
# Returns `true` if *stat* is a directory,
# `false` otherwise.
#
#    File.stat("testfile").directory?   #=> false
#    File.stat(".").directory?          #=> true
#
def stat.directory?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.pipe?   -> true or false
#
# Returns `true` if the operating system supports pipes and
# *stat* is a pipe; `false` otherwise.
#
def stat.pipe?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.symlink?   -> true or false
#
# Returns `true` if *stat* is a symbolic link,
# `false` if it isn't or if the operating system doesn't
# support this feature. As `File::stat` automatically
# follows symbolic links, `symlink?` will always be
# `false` for an object returned by
# `File::stat`.
#
#    File.symlink("testfile", "alink")   #=> 0
#    File.stat("alink").symlink?         #=> false
#    File.lstat("alink").symlink?        #=> true
#
#
def stat.symlink?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.socket?   -> true or false
#
# Returns `true` if *stat* is a socket,
# `false` if it isn't or if the operating system doesn't
# support this feature.
#
#    File.stat("testfile").socket?   #=> false
#
#
def stat.socket?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.blockdev?  -> true or false
#
# Returns `true` if the file is a block device,
# `false` if it isn't or if the operating system doesn't
# support this feature.
#
#    File.stat("testfile").blockdev?    #=> false
#    File.stat("/dev/hda1").blockdev?   #=> true
#
#
def stat.blockdev?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.chardev?   -> true or false
#
# Returns `true` if the file is a character device,
# `false` if it isn't or if the operating system doesn't
# support this feature.
#
#    File.stat("/dev/tty").chardev?   #=> true
#
#
def stat.chardev?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.owned?   -> true or false
#
# Returns `true` if the effective user id of the process is
# the same as the owner of *stat*.
#
#    File.stat("testfile").owned?      #=> true
#    File.stat("/etc/passwd").owned?   #=> false
#
#
def stat.owned?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.grpowned?  -> true or false
#
# Returns true if the effective group id of the process is the same as
# the group id of *stat*. On Windows NT, returns `false`.
#
#    File.stat("testfile").grpowned?      #=> true
#    File.stat("/etc/passwd").grpowned?   #=> false
#
#
def stat.grpowned?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.readable?   -> true or false
#
# Returns `true` if *stat* is readable by the
# effective user id of this process.
#
#    File.stat("testfile").readable?   #=> true
#
#
def stat.readable?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.readable_real? ->  true or false
#
# Returns `true` if *stat* is readable by the real
# user id of this process.
#
#    File.stat("testfile").readable_real?   #=> true
#
#
def stat.readable_real?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.world_readable?-> fixnum or nil
#
#If *stat* is readable by others, returns an integer
#representing the file permission bits of *stat*. Returns
#`nil` otherwise. The meaning of the bits is platform
#dependent; on Unix systems, see `stat(2)`.
#
#   m = File.stat("/etc/passwd").world_readable?  #=> 420
#   sprintf("%o", m)                              #=> "644"
#
def stat.world_readable?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.writable? ->  true or false
#
# Returns `true` if *stat* is writable by the
# effective user id of this process.
#
#    File.stat("testfile").writable?   #=> true
#
#
def stat.writable?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.writable_real? ->  true or false
#
# Returns `true` if *stat* is writable by the real
# user id of this process.
#
#    File.stat("testfile").writable_real?   #=> true
#
#
def stat.writable_real?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.world_writable? ->  fixnum or nil
#
#If *stat* is writable by others, returns an integer
#representing the file permission bits of *stat*. Returns
#`nil` otherwise. The meaning of the bits is platform
#dependent; on Unix systems, see `stat(2)`.
#
#   m = File.stat("/tmp").world_writable?         #=> 511
#   sprintf("%o", m)                              #=> "777"
#
def stat.world_writable?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.executable?   -> true or false
#
# Returns `true` if *stat* is executable or if the
# operating system doesn't distinguish executable files from
# nonexecutable files. The tests are made using the effective owner of
# the process.
#
#    File.stat("testfile").executable?   #=> false
#
#
def stat.executable?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.executable_real?   -> true or false
#
# Same as `executable?`, but tests using the real owner of
# the process.
#
def stat.executable_real?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.file?   -> true or false
#
# Returns `true` if *stat* is a regular file (not
# a device file, pipe, socket, etc.).
#
#    File.stat("testfile").file?   #=> true
#
#
def stat.file?()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   stat.zero?   -> true or false
#
# Returns `true` if *stat* is a zero-length file;
# `false` otherwise.
#
#    File.stat("testfile").zero?   #=> false
#
#
def stat.zero?()
  NoMethodError.abstract(self)
end

    end
  end
end
