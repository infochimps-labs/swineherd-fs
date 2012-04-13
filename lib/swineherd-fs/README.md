This library provides the regular ruby filesystem interface (`File`, `Pathname`, etc) on top of distributed file systems and blob stores. It has support for Hadoop's HDFS, Amazon's S3, an S3 HDFS, and regular (local) files, giving them as-closely-as-reasonable the experience you already know.

## Components

The Filesystem class must implement:

  - #copy -- within fs
  - #move -- within fs
  - #copy_from_local
  - #copy_to_local
  - #mkdir
  - #rmdir
  - #unlink

  - #utime
  - #chmod
  - #chown
  
  - #open
  - #read
  - #write
  - #close

  - #each_entry(&block)

  - #scheme (port, host too if appl.)
  - #atime
  - #ctime
  - #mtime
  - #ftype
  - #mode
  - #size
  - #blocks
  - #blksize
  - #uid
  - #gid

It may optionally implement

  - #lchmod(mode)
  - #lchown(owner, group)
  - #make_link(old)
  - #make_symlink(old)
  - #truncate(length)
  - #concat
  - #copy_merge
  - #append

* Wukong::WuPathname --

* Wukong::WuFile
* Wukong::WuFile::Stat
* Wukong::WuIo


* Core pathname methods don't access the filesystem
  - +
  - #join
  - #parent
  - #root?
  - #absolute?
  - #relative?
  - #relative_path_from
  - #each_filename
  - #cleanpath
  - #path

  - #basename(*args)
  - #dirname
  - #extname
  - #expand_path(*args)
  - #absolute_path
  - #split

  - #fnmatch(pattern, *args)
  - #fnmatch?(pattern, *args)

  - Pathname.glob(*args)
  - #entries
  - #each_entry(&block)

  - #children
  - #each_child

  - NO: #readlink
  - NO: #realpath
  - NO: #realdirpath
  - NO: #mountpoint?

* `FileUtils`

  - #chmod
  - #chown
  - #chmod_R
  - #chown_R
  
  - #cmp
  - #compare_file
  - #compare_stream
  - #identical?
  
  - #copy / #cp / #cp_r / #copy_entry / #copy_file / #copy_stream
  - #move / #mv

  - #link
  - #ln
  - #ln_s
  - #ln_sf

  - #makedirs
  - #mkdir
  - #mkdir_p
  - #mkpath

  - #mkpath
  - #rmtree
  - #opendir(*args)
  - #glob(*args)
  - #entries
  - #binread(*args)
  - #readlines(*args)
  - #each_line
  - exists?

  - #remove
  - #safe_unlink
  - #rm
  - #rm_f
  - #rm_r
  - #rm_rf
  - #remove_dir
  - #rmdir
  - #remove_entry
  - #remove_entry_secure
  - #remove_file
 
  - #rmtree
  - #symlink
  - #touch
  - #uptodate?

* `Stat` holds filesystem metadata.

  - #stat
  - #lstat

  - #atime
  - #ctime
  - #mtime
  - #ftype
  - #mode
  - #size
  - #blocks
  - #blksize
  - #uid
  - #gid


* `WuFileTest` methods rely on the relevant `stat` commands

  - #utime(atime, mtime)
  - #chmod(mode)
  - #lchmod(mode)
  - #chown(owner, group)
  - #lchown(owner, group)

  - #rename(to)

  - #make_link(old)
  - #make_symlink(old)

  - #mkdir(*args)
  - #rmdir
  - #opendir(*args)
  - #mkpath
  - #rmtree
  - #unlink / #delete

  - #open(*args, &block)
  - #truncate(length)
  - #each_line(*args, &block)
  - #read(*args)
  - #binread(*args)
  - #readlines(*args)

* These are not implemented:

  - Pathname.getwd / Pathname.pwd
  - #cd / #chdir
  - #find(&block)
  - umask
  - test
  - #sysopen(*args)
  - #install
  
## Caveats

The mantra is *as close as reasonable* and *no surprises*. 

This is a filesystem *abstraction*.

* Making a symlink is a pretty useful thing, but many file systems don't support it.
* The HDFS is a read-only file system, but recent versions allow an `append` operation
*

We've tried to strike a balance among

* doing what you want
* be confident that using a methor

In fact, we've chosen to omit them even when they would
We've chosen to omit
Some important differences:

### Methods not included in the interface

 advanced methods that only make sense in context of a POSIX file system: `ino`, `dev{,_minor,_major}`, and several others.


### s3n (Native S3)

* There is no proper notion of a 'directory' on s3n, so `mkdir` is a no-op and `directory?` is only true if there is a descendant somewhere.

* `append` -- s3n does not support .

### HDFS

The following is true for both regular (distributed) HDFS and an s3-backed HDFS.

HDFS is append-only
*

Yo __bacon_flavored_ham_
