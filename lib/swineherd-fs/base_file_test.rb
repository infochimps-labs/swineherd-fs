# FileTest
#
# FileTest implements file test operations similar to those used in
# File::Stat. The methods in FileTest are duplicated in class File. Rather than
# repeat the documentation here, we list the names of the methods and refer
# you to the documentation for File starting on page 444. FileTest appears to a
# somewhat vestigial module.
#
# The FileTest methods are
#
# blockdev?, chardev?, directory?, executable?, executable_real?, exist?,
# exists?, file?, grpowned?, owned?, pipe?, readable?, readable_real?, setgid?,
# setuid?, size, size?, socket?, sticky?, symlink?, world_readable?,
# world_writable?, writable?, writable_real?, and zero?
#


#
# Document-class: FileTest
#
# `FileTest` implements file test operations similar to
# those used in `File::Stat`. It exists as a standalone
# module, and its methods are also insinuated into the `File`
# class. (Note that this is not done by inclusion: the interpreter cheats).
#
#
#
#Document-method: exist?
#
#call-seq:
#  Dir.exist?(file_name)   ->  true or false
#  Dir.exists?(file_name)   ->  true or false
#
#Returns `true` if the named file is a directory,
#`false` otherwise.
#
#
#
#Document-method: directory?
#
#call-seq:
#  File.directory?(file_name)   ->  true or false
#
#Returns `true` if the named file is a directory,
#or a symlink that points at a directory, and `false`
#otherwise.
#
#   File.directory?(".")
#
#
# call-seq:
#   File.pipe?(file_name)  ->  true or false
#
#Returns `true` if the named file is a pipe.
#
def File.pipe?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.symlink?(file_name)  ->  true or false
#
#Returns `true` if the named file is a symbolic link.
#
def File.symlink?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.socket?(file_name)  ->  true or false
#
#Returns `true` if the named file is a socket.
#
def File.socket?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.blockdev?(file_name)  ->  true or false
#
#Returns `true` if the named file is a block device.
#
def File.blockdev?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.chardev?(file_name)  ->  true or false
#
#Returns `true` if the named file is a character device.
#
def File.chardev?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.exist?(file_name)   ->  true or false
#   File.exists?(file_name)   ->  true or false
#
#Return `true` if the named file exists.
#
def File.exist?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.readable?(file_name)  -> true or false
#
#Returns `true` if the named file is readable by the effective
#user id of this process.
#
def File.readable?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.readable_real?(file_name)  -> true or false
#
#Returns `true` if the named file is readable by the real
#user id of this process.
#
def File.readable_real?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.world_readable?(file_name)  -> fixnum or nil
#
#If *file_name* is readable by others, returns an integer
#representing the file permission bits of *file_name*. Returns
#`nil` otherwise. The meaning of the bits is platform
#dependent; on Unix systems, see `stat(2)`.
#
#   File.world_readable?("/etc/passwd")           #=> 420
#   m = File.world_readable?("/etc/passwd")
#   sprintf("%o", m)                              #=> "644"
#
def File.world_readable?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.writable?(file_name)  -> true or false
#
#Returns `true` if the named file is writable by the effective
#user id of this process.
#
def File.writable?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.writable_real?(file_name)  -> true or false
#
#Returns `true` if the named file is writable by the real
#user id of this process.
#
def File.writable_real?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.world_writable?(file_name)  -> fixnum or nil
#
#If *file_name* is writable by others, returns an integer
#representing the file permission bits of *file_name*. Returns
#`nil` otherwise. The meaning of the bits is platform
#dependent; on Unix systems, see `stat(2)`.
#
#   File.world_writable?("/tmp")                  #=> 511
#   m = File.world_writable?("/tmp")
#   sprintf("%o", m)                              #=> "777"
#
def File.world_writable?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.executable?(file_name)  -> true or false
#
#Returns `true` if the named file is executable by the effective
#user id of this process.
#
def File.executable?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.executable_real?(file_name)  -> true or false
#
#Returns `true` if the named file is executable by the real
#user id of this process.
#
def File.executable_real?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.file?(file_name)  -> true or false
#
#Returns `true` if the named file exists and is a
#regular file.
#
def File.file?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.zero?(file_name)  -> true or false
#
#Returns `true` if the named file exists and has
#a zero size.
#
def File.zero?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.size?(file_name)  -> Integer or nil
#
#Returns +nil+ if +file_name+ doesn't exist or has zero size, the size of the
#file otherwise.
#
def File.size?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.owned?(file_name)  -> true or false
#
#Returns `true` if the named file exists and the
#effective used id of the calling process is the owner of
#the file.
#
def File.owned?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.grpowned?(file_name)  -> true or false
#
#Returns `true` if the named file exists and the
#effective group id of the calling process is the owner of
#the file. Returns `false` on Windows.
#
def File.grpowned?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.setuid?(file_name)  ->  true or false
#
#Returns `true` if the named file has the setuid bit set.
#
def File.setuid?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.setgid?(file_name)  ->  true or false
#
#Returns `true` if the named file has the setgid bit set.
#
def File.setgid?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.sticky?(file_name)  ->  true or false
#
#Returns `true` if the named file has the sticky bit set.
#
def File.sticky?(file_name)()
  NoMethodError.abstract(self)
end

#
# call-seq:
#   File.identical?(file_1,file_2)   ->  true or false
#
#Returns `true` if the named files are identical.
#
#    open("a", "w") {}
#    p File.identical?("a", "a")      #=> true
#    p File.identical?("a", "./a")    #=> true
#    File.link("a", "b")
#    p File.identical?("a", "b")      #=> true
#    File.symlink("a", "c")
#    p File.identical?("a", "c")      #=> true
#    open("d", "w") {}
#    p File.identical?("a", "d")      #=> false
#
def File.identical?(file_1,file_2)
  NoMethodError.abstract(self)
end
