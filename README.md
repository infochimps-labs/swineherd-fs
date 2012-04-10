# Swineherd File System Abstractions

At Infochimps, much of our daily routine involves processing and moving data from one location to another. This often involves several different file systems and managing different the sytnax and style associated with each can be quite cumbersome, especially those systems which do not readily allow for code interaction. Thus, swineherd-fs was born of necessity, to allow us to have but one general abstraction for file system interaction that could apply across our entire data stack. It was designed to give users a unified, *NIX-like syntax for interacting with multiple file systems at the same time, with an emphasis on file management.

* __file__ - Local file system. Only thoroughly tested on Ubuntu Linux.
* __hdfs__ - Hadoop distributed file system. Uses the Apache Hadoop 0.20 API. Requires JRuby.
* __s3__   - Amazon Simple Storage System (s3).
* __ftp__  - FTP (Not yet implemented)

All filesystem abstractions implement the following core methods, based on standard UNIX functions, and Ruby's `File` class:

* __mv__
* __cp__
* __cp_r__
* __rm__
* __rm_r__
* __open__
* __exists?__
* __directory?__
* __ls__
* __ls_r__
* __mkdir_p__

Additionally, the S3 and HDFS abstractions implement these methods for moving files to and from the local filesystem:

* __copy_to_local__
* __copy_from_local__

## FileSystem

The `Swineherd::FileSystem` module implements a generic filesystem abstraction using schemed filepaths prefixes (`hdfs://`, `s3://`, `file://`). Currently only the following methods are implemented:

* __cp__
* __exists?__
    
For example, instead of needing to doing the following:

```ruby
hdfs = Swineherd::HadoopFileSystem.new
localfs = Swineherd::LocalFileSystem.new
hdfs.copy_to_local('foo/bar/baz.txt', 'foo/bar/baz.txt') unless localfs.exists? 'foo/bar/baz.txt'
```
    
You can do this instead:

```ruby
fs = Swineherd::FileSystem
fs.cp('hdfs://foo/bar/baz.txt','foo/bar/baz.txt') unless fs.exists?('foo/bar/baz.txt')
```

Which is easier to read and easier to manage.

Note: A path without a scheme prefix is treated as a path on the local filesystem; use the explicit `file://` scheme prefix for clarity.  The following are equivalent:

```ruby
fs.exists?('foo/bar/baz.txt')
fs.exists?('file://foo/bar/baz.txt')
```

Use the generic `Swineherd::FileSystem` for simple scripts that only require a little file management. For anything heavyweight, it is recommended to instantiate a FileSystem object for each system you are interacting with, in order to have more fine-grained control.

## S3FileSystem

### Caveats

Since S3 is actually just a key-value store, it is difficult to preserve the notion of a directory. Therefore, the `mkdir_p` method has no real purpose, as there cannot be empty directories. `mkdir_p` currently only ensures that the bucket exists.  This implies that the `directory?` method returns true only if the directory is non-empty, which is misleading.

### Config

In order to use the `Swineherd::S3FileSystem`, Swineherd requires AWS S3 credentials.

Create a YAML file in either `~/swineherd.yaml` or `/etc/swineherd.yaml` and populate with:

```ruby
aws:
  access_key: my_access_key
  secret_key: my_secret_key
```

Swineherd will automatically find the credentials if they are present in one of the above locations:

```ruby
s3fs = Swineherd::FileSystem.get(:s3)
```

Or, just pass them in when creating the instance: 

```ruby
s3fs = Swineherd::FileSystem.get(:s3, :access_key => "my_access_key", 
                                      :secret_key => "my_secret_key")
```

## HadoopFileSystem

### Dependencies

Since the `Swineherd::HadoopFileSystem` abstraction relies on Java's native Hadoop libraries, jruby is required. Homebrew is the recommended way to install jruby. swineherd-fs was tested with version 1.6.5

```
brew install jruby
jruby -S gem install swineherd-fs
```

In the jirb shell:

```ruby
require 'swineherd-fs'
hdfs = Swineherd::FileSystem.get(:hdfs)
hdfs.ls("/home/yo_momma/")
=> ["hdfs://ip_address.local/home/yo_momma/is_so_fat.txt"]
 hdfs.exists?("/home/yo_momma/is_so_fat.txt")
=> true
```
