#
# == module FileUtils
#
# Namespace for several file utility methods for copying, moving, removing, etc.
#
# === Module Functions
#

#   makedirs(list, options)
#     mkdir_p -- equivalent of makedirs with `:recursive => true`
#     mkdir   -- equivalent of makedirs with `:recursive => false`
#   remove_dirs(list, options)
#     rmdir   -- alias for remove_dirs
#
#   copy
#     cp(src, dest, options)
#     cp(list, dir, options)
#     cp_r(src, dest, options)
#     cp_r(list, dir, options)
#   move
#     mv(src, dest, options)
#     mv(list, dir, options)
#
#   remove(list, options)
#     rm    -- equivalent of remove
#     rm_r  -- equivalent of remove with `:recursive => true`
#     rm_rf -- equivalent of remove with `:recursive => true, :force => true`
#
#   chmod
#     chmod(mode, list, options)
#     chmod_R(mode, list, options)
#
#   chown
#     chown(user, group, list, options)
#     chown_R(user, group, list, options)
#
#   touch(list, options)
#
#   link
#     ln(old, new, options)
#     ln(list, destdir, options)
#     ln_s(old, new, options)
#     ln_s(list, destdir, options)
#     ln_sf(src, dest, options)

#   uptodate?

# It is largely identical to the interface for FileUtils with the following exceptions:
#
# * `ln` and `ln_s` are optional. Calling them raises an error unless the
#   `:fallback => :copy` option is given, in which case it delegates to cp.
# * There are no `cd`, `pwd` and `install` methods

#
# The `options` parameter is a hash of options, taken from the list
#   `:force`, `:noop`, `:preserve`, and `:verbose`.
# `:noop` means that no changes are made.  The other two are obvious.
# Each method documents the options that it honours.
#
# All methods that have the concept of a "source" file or directory can take
# either one file or a list of files in that argument.  See the method
# documentation for examples.
#

module FileUtils
  @fileutils_output  = $stderr
  @fileutils_label   = ''
  extend self

  # This hash table holds command options.
  OPT_TABLE = {}   #:nodoc: internal use only

  #
  # Options: (none)
  #
  # Returns true if +newer+ is newer than all +old_list+.
  # Non-existent files are older than any file.
  #
  #   FileUtils.uptodate?('hello.o', %w(hello.c hello.h)) or \
  #       system 'make hello.o'
  #
  def uptodate?(new, old_list, options = nil)
    raise ArgumentError, 'uptodate? does not accept any option' if options

    return false unless File.exist?(new)
    new_time = File.mtime(new)
    old_list.each do |old|
      if File.exist?(old)
        return false unless new_time > File.mtime(old)
      end
    end
    true
  end

  #
  # Options: mode noop verbose
  #
  # Creates one or more directories.
  #
  #   FileUtils.mkdir 'test'
  #   FileUtils.mkdir %w( tmp data )
  #   FileUtils.mkdir 'notexist', :noop => true  # Does not really create.
  #   FileUtils.mkdir 'tmp', :mode => 0700
  #
  def mkdir(list, options = {})
    fu_check_options options, OPT_TABLE['mkdir']
    list = fu_list(list)
    fu_output_message "mkdir #{options[:mode] ? ('-m %03o ' % options[:mode]) : ''}#{list.join ' '}" if options[:verbose]
    return if options[:noop]

    list.each do |dir|
      fu_mkdir dir, options[:mode]
    end
  end

  define_command('mkdir', :mode, :noop, :verbose)

  #
  # Options: mode noop verbose
  #
  # Creates a directory and all its parent directories.
  # For example,
  #
  #   FileUtils.mkdir_p '/usr/local/lib/ruby'
  #
  # causes to make following directories, if it does not exist.
  #     * /usr
  #     * /usr/local
  #     * /usr/local/lib
  #     * /usr/local/lib/ruby
  #
  # You can pass several directories at a time in a list.
  #
  def mkdir_p(list, options = {})
    fu_check_options options, OPT_TABLE['mkdir_p']
    list = fu_list(list)
    fu_output_message "mkdir -p #{options[:mode] ? ('-m %03o ' % options[:mode]) : ''}#{list.join ' '}" if options[:verbose]
    return *list if options[:noop]

    list.map {|path| path.chomp(?/) }.each do |path|
      # optimize for the most common case
      begin
        fu_mkdir path, options[:mode]
        next
      rescue SystemCallError
        next if File.directory?(path)
      end

      stack = []
      until path == stack.last   # dirname("/")=="/", dirname("C:/")=="C:/"
        stack.push path
        path = File.dirname(path)
      end
      stack.reverse_each do |dir|
        begin
          fu_mkdir dir, options[:mode]
        rescue SystemCallError
          raise unless File.directory?(dir)
        end
      end
    end

    return *list
  end
  alias makedirs  mkdir_p

  #
  # Options: noop, verbose
  #
  # Removes one or more directories.
  #
  #   FileUtils.rmdir 'somedir'
  #   FileUtils.rmdir %w(somedir anydir otherdir)
  #   # Does not really remove directory; outputs message.
  #   FileUtils.rmdir 'somedir', :verbose => true, :noop => true
  #
  def rmdir(list, options = {})
    fu_check_options options, OPT_TABLE['rmdir']
    list = fu_list(list)
    parents = options[:parents]
    fu_output_message "rmdir #{parents ? '-p ' : ''}#{list.join ' '}" if options[:verbose]
    return if options[:noop]
    list.each do |dir|
      begin
        Dir.rmdir(dir = dir.chomp(?/))
        if parents
          until (parent = File.dirname(dir)) == '.' or parent == dir
            Dir.rmdir(dir)
          end
        end
      rescue Errno::ENOTEMPTY, Errno::ENOENT
      end
    end
  end

  #
  # Options: force noop verbose
  #
  # <b><tt>ln(old, new, options = {})</tt></b>
  #
  # Creates a hard link +new+ which points to +old+.
  # If +new+ already exists and it is a directory, creates a link +new/old+.
  # If +new+ already exists and it is not a directory, raises Errno::EEXIST.
  # But if :force option is set, overwrite +new+.
  #
  #   FileUtils.ln 'gcc', 'cc', :verbose => true
  #   FileUtils.ln '/usr/bin/emacs21', '/usr/bin/emacs'
  #
  # <b><tt>ln(list, destdir, options = {})</tt></b>
  #
  # Creates several hard links in a directory, with each one pointing to the
  # item in +list+.  If +destdir+ is not a directory, raises Errno::ENOTDIR.
  #
  #   include FileUtils
  #   cd '/sbin'
  #   FileUtils.ln %w(cp mv mkdir), '/bin'   # Now /sbin/cp and /bin/cp are linked.
  #
  def ln(src, dest, options = {})
    fu_check_options options, OPT_TABLE['ln']
    fu_output_message "ln#{options[:force] ? ' -f' : ''} #{[src,dest].flatten.join ' '}" if options[:verbose]
    return if options[:noop]
    fu_each_src_dest0(src, dest) do |s,d|
      remove_file d, true if options[:force]
      File.link s, d
    end
  end

  alias link ln


  #
  # Options: force noop verbose
  #
  # <b><tt>ln_s(old, new, options = {})</tt></b>
  #
  # Creates a symbolic link +new+ which points to +old+.  If +new+ already
  # exists and it is a directory, creates a symbolic link +new/old+.  If +new+
  # already exists and it is not a directory, raises Errno::EEXIST.  But if
  # :force option is set, overwrite +new+.
  #
  #   FileUtils.ln_s '/usr/bin/ruby', '/usr/local/bin/ruby'
  #   FileUtils.ln_s 'verylongsourcefilename.c', 'c', :force => true
  #
  # <b><tt>ln_s(list, destdir, options = {})</tt></b>
  #
  # Creates several symbolic links in a directory, with each one pointing to the
  # item in +list+.  If +destdir+ is not a directory, raises Errno::ENOTDIR.
  #
  # If +destdir+ is not a directory, raises Errno::ENOTDIR.
  #
  #   FileUtils.ln_s Dir.glob('bin/*.rb'), '/home/aamine/bin'
  #
  def ln_s(src, dest, options = {})
    fu_check_options options, OPT_TABLE['ln_s']
    fu_output_message "ln -s#{options[:force] ? 'f' : ''} #{[src,dest].flatten.join ' '}" if options[:verbose]
    return if options[:noop]
    fu_each_src_dest0(src, dest) do |s,d|
      remove_file d, true if options[:force]
      File.symlink s, d
    end
  end

  alias symlink ln_s


  #
  # Options: noop verbose
  #
  # Same as
  #   #ln_s(src, dest, :force)
  #
  def ln_sf(src, dest, options = {})
    fu_check_options options, OPT_TABLE['ln_sf']
    options = options.dup
    options[:force] = true
    ln_s src, dest, options
  end


  #
  # Options: preserve noop verbose
  #
  # Copies a file content +src+ to +dest+.  If +dest+ is a directory,
  # copies +src+ to +dest/src+.
  #
  # If +src+ is a list of files, then +dest+ must be a directory.
  #
  #   FileUtils.cp 'eval.c', 'eval.c.org'
  #   FileUtils.cp %w(cgi.rb complex.rb date.rb), '/usr/lib/ruby/1.6'
  #   FileUtils.cp %w(cgi.rb complex.rb date.rb), '/usr/lib/ruby/1.6', :verbose => true
  #   FileUtils.cp 'symlink', 'dest'   # copy content, "dest" is not a symlink
  #
  def cp(src, dest, options = {})
    fu_check_options options, OPT_TABLE['cp']
    fu_output_message "cp#{options[:preserve] ? ' -p' : ''} #{[src,dest].flatten.join ' '}" if options[:verbose]
    return if options[:noop]
    fu_each_src_dest(src, dest) do |s, d|
      copy_file s, d, options[:preserve]
    end
  end

  alias copy cp


  #
  # Options: preserve noop verbose dereference_root remove_destination
  #
  # Copies +src+ to +dest+. If +src+ is a directory, this method copies
  # all its contents recursively. If +dest+ is a directory, copies
  # +src+ to +dest/src+.
  #
  # +src+ can be a list of files.
  #
  #   # Installing ruby library "mylib" under the site_ruby
  #   FileUtils.rm_r site_ruby + '/mylib', :force
  #   FileUtils.cp_r 'lib/', site_ruby + '/mylib'
  #
  #   # Examples of copying several files to target directory.
  #   FileUtils.cp_r %w(mail.rb field.rb debug/), site_ruby + '/tmail'
  #   FileUtils.cp_r Dir.glob('*.rb'), '/home/aamine/lib/ruby', :noop => true, :verbose => true
  #
  #   # If you want to copy all contents of a directory instead of the
  #   # directory itself, c.f. src/x -> dest/x, src/y -> dest/y,
  #   # use following code.
  #   FileUtils.cp_r 'src/.', 'dest'     # cp_r('src', 'dest') makes src/dest,
  #                                      # but this doesn't.
  #
  def cp_r(src, dest, options = {})
    fu_check_options options, OPT_TABLE['cp_r']
    fu_output_message "cp -r#{options[:preserve] ? 'p' : ''}#{options[:remove_destination] ? ' --remove-destination' : ''} #{[src,dest].flatten.join ' '}" if options[:verbose]
    return if options[:noop]
    options = options.dup
    options[:dereference_root] = true unless options.key?(:dereference_root)
    fu_each_src_dest(src, dest) do |s, d|
      copy_entry s, d, options[:preserve], options[:dereference_root], options[:remove_destination]
    end
  end

  #
  # Copies a file system entry +src+ to +dest+.
  # If +src+ is a directory, this method copies its contents recursively.
  # This method preserves file types, c.f. symlink, directory...
  # (FIFO, device files and etc. are not supported yet)
  #
  # Both of +src+ and +dest+ must be a path name.
  # +src+ must exist, +dest+ must not exist.
  #
  # If +preserve+ is true, this method preserves owner, group, permissions
  # and modified time.
  #
  # If +dereference_root+ is true, this method dereference tree root.
  #
  # If +remove_destination+ is true, this method removes each destination file before copy.
  #
  def copy_entry(src, dest, preserve = false, dereference_root = false, remove_destination = false)
    Entry_.new(src, nil, dereference_root).traverse do |ent|
      destent = Entry_.new(dest, ent.rel, false)
      File.unlink destent.path if remove_destination && File.file?(destent.path)
      ent.copy destent.path
      ent.copy_metadata destent.path if preserve
    end
  end


  #
  # Copies file contents of +src+ to +dest+.
  # Both of +src+ and +dest+ must be a path name.
  #
  def copy_file(src, dest, preserve = false, dereference = true)
    ent = Entry_.new(src, nil, dereference)
    ent.copy_file dest
    ent.copy_metadata dest if preserve
  end


  #
  # Copies stream +src+ to +dest+.
  # +src+ must respond to #read(n) and
  # +dest+ must respond to #write(str).
  #
  def copy_stream(src, dest)
    IO.copy_stream(src, dest)
  end


  #
  # Options: force noop verbose
  #
  # Moves file(s) +src+ to +dest+.  If +file+ and +dest+ exist on the different
  # disk partition, the file is copied then the original file is removed.
  #
  #   FileUtils.mv 'badname.rb', 'goodname.rb'
  #   FileUtils.mv 'stuff.rb', '/notexist/lib/ruby', :force => true  # no error
  #
  #   FileUtils.mv %w(junk.txt dust.txt), '/home/aamine/.trash/'
  #   FileUtils.mv Dir.glob('test*.rb'), 'test', :noop => true, :verbose => true
  #
  def mv(src, dest, options = {})
    fu_check_options options, OPT_TABLE['mv']
    fu_output_message "mv#{options[:force] ? ' -f' : ''} #{[src,dest].flatten.join ' '}" if options[:verbose]
    return if options[:noop]
    fu_each_src_dest(src, dest) do |s, d|
      destent = Entry_.new(d, nil, true)
      begin
        if destent.exist?
          if destent.directory?
            raise Errno::EEXIST, dest
          else
            destent.remove_file if rename_cannot_overwrite_file?
          end
        end
        begin
          File.rename s, d
        rescue Errno::EXDEV
          copy_entry s, d, true
          if options[:secure]
            remove_entry_secure s, options[:force]
          else
            remove_entry s, options[:force]
          end
        end
      rescue SystemCallError
        raise unless options[:force]
      end
    end
  end

  alias move mv


private

  def rename_cannot_overwrite_file?   #:nodoc:
    /cygwin|mswin|mingw|bccwin|emx/ =~ RUBY_PLATFORM
  end

public

  #
  # Options: force noop verbose
  #
  # Remove file(s) specified in +list+.  This method cannot remove directories.
  # All StandardErrors are ignored when the :force option is set.
  #
  #   FileUtils.rm %w( junk.txt dust.txt )
  #   FileUtils.rm Dir.glob('*.so')
  #   FileUtils.rm 'NotExistFile', :force => true   # never raises exception
  #
  def rm(list, options = {})
    fu_check_options options, OPT_TABLE['rm']
    list = fu_list(list)
    fu_output_message "rm#{options[:force] ? ' -f' : ''} #{list.join ' '}" if options[:verbose]
    return if options[:noop]

    list.each do |path|
      remove_file path, options[:force]
    end
  end

  alias remove rm


  #
  # Options: noop verbose
  #
  # Equivalent to
  #
  #   #rm(list, :force => true)
  #
  def rm_f(list, options = {})
    fu_check_options options, OPT_TABLE['rm_f']
    options = options.dup
    options[:force] = true
    rm list, options
  end

  alias safe_unlink rm_f

  #
  # Options: force noop verbose secure
  #
  # remove files +list+[0] +list+[1]... If +list+[n] is a directory,
  # removes its all contents recursively. This method ignores
  # StandardError when :force option is set.
  #
  #   FileUtils.rm_r Dir.glob('/tmp/*')
  #   FileUtils.rm_r '/', :force => true          #  :-)
  #
  # WARNING: This method causes local vulnerability
  # if one of parent directories or removing directory tree are world
  # writable (including /tmp, whose permission is 1777), and the current
  # process has strong privilege such as Unix super user (root), and the
  # system has symbolic link.  For secure removing, read the documentation
  # of #remove_entry_secure carefully, and set :secure option to true.
  # Default is :secure=>false.
  #
  # NOTE: This method calls #remove_entry_secure if :secure option is set.
  # See also #remove_entry_secure.
  #
  def rm_r(list, options = {})
    fu_check_options options, OPT_TABLE['rm_r']
    # options[:secure] = true unless options.key?(:secure)
    list = fu_list(list)
    fu_output_message "rm -r#{options[:force] ? 'f' : ''} #{list.join ' '}" if options[:verbose]
    return if options[:noop]
    list.each do |path|
      if options[:secure]
        remove_entry_secure path, options[:force]
      else
        remove_entry path, options[:force]
      end
    end
  end


  #
  # Options: noop verbose secure
  #
  # Equivalent to
  #
  #   #rm_r(list, :force => true)
  #
  # WARNING: This method causes local vulnerability.
  # Read the documentation of #rm_r first.
  #
  def rm_rf(list, options = {})
    fu_check_options options, OPT_TABLE['rm_rf']
    options = options.dup
    options[:force] = true
    rm_r list, options
  end

  alias rmtree rm_rf


  #
  # This method removes a file system entry +path+.  +path+ shall be a
  # regular file, a directory, or something.  If +path+ is a directory,
  # remove it recursively.  This method is required to avoid TOCTTOU
  # (time-of-check-to-time-of-use) local security vulnerability of #rm_r.
  # #rm_r causes security hole when:
  #
  #   * Parent directory is world writable (including /tmp).
  #   * Removing directory tree includes world writable directory.
  #   * The system has symbolic link.
  #
  # To avoid this security hole, this method applies special preprocess.
  # If +path+ is a directory, this method chown(2) and chmod(2) all
  # removing directories.  This requires the current process is the
  # owner of the removing whole directory tree, or is the super user (root).
  #
  # WARNING: You must ensure that *ALL* parent directories cannot be
  # moved by other untrusted users.  For example, parent directories
  # should not be owned by untrusted users, and should not be world
  # writable except when the sticky bit set.
  #
  # WARNING: Only the owner of the removing directory tree, or Unix super
  # user (root) should invoke this method.  Otherwise this method does not
  # work.
  #
  # For details of this security vulnerability, see Perl's case:
  #
  #   http://www.cve.mitre.org/cgi-bin/cvename.cgi?name=CAN-2005-0448
  #   http://www.cve.mitre.org/cgi-bin/cvename.cgi?name=CAN-2004-0452
  #
  # For fileutils.rb, this vulnerability is reported in [ruby-dev:26100].
  #
  def remove_entry_secure(path, force = false)
    unless fu_have_symlink?
      remove_entry path, force
      return
    end
    fullpath = File.expand_path(path)
    st = File.lstat(fullpath)
    unless st.directory?
      File.unlink fullpath
      return
    end
    # is a directory.
    parent_st = File.stat(File.dirname(fullpath))
    unless parent_st.world_writable?
      remove_entry path, force
      return
    end
    unless parent_st.sticky?
      raise ArgumentError, "parent directory is world writable, FileUtils#remove_entry_secure does not work; abort: #{path.inspect} (parent directory mode #{'%o' % parent_st.mode})"
    end
    # freeze tree root
    euid = Process.euid
    File.open(fullpath + '/.') {|f|
      unless fu_stat_identical_entry?(st, f.stat)
        # symlink (TOC-to-TOU attack?)
        File.unlink fullpath
        return
      end
      f.chown euid, -1
      f.chmod 0700
      unless fu_stat_identical_entry?(st, File.lstat(fullpath))
        # TOC-to-TOU attack?
        File.unlink fullpath
        return
      end
    }
    # ---- tree root is frozen ----
    root = Entry_.new(path)
    root.preorder_traverse do |ent|
      if ent.directory?
        ent.chown euid, -1
        ent.chmod 0700
      end
    end
    root.postorder_traverse do |ent|
      begin
        ent.remove
      rescue
        raise unless force
      end
    end
  rescue
    raise unless force
  end

  #
  # This method removes a file system entry +path+.
  # +path+ might be a regular file, a directory, or something.
  # If +path+ is a directory, remove it recursively.
  #
  # See also #remove_entry_secure.
  #
  def remove_entry(path, force = false)
    Entry_.new(path).postorder_traverse do |ent|
      begin
        ent.remove
      rescue
        raise unless force
      end
    end
  rescue
    raise unless force
  end

  #
  # Removes a file +path+.
  # This method ignores StandardError if +force+ is true.
  #
  def remove_file(path, force = false)
    Entry_.new(path).remove_file
  rescue
    raise unless force
  end


  #
  # Removes a directory +dir+ and its contents recursively.
  # This method ignores StandardError if +force+ is true.
  #
  def remove_dir(path, force = false)
    remove_entry path, force   # FIXME?? check if it is a directory
  end


  #
  # Returns true if the contents of a file A and a file B are identical.
  #
  #   FileUtils.compare_file('somefile', 'somefile')  #=> true
  #   FileUtils.compare_file('/bin/cp', '/bin/mv')    #=> maybe false
  #
  def compare_file(a, b)
    return false unless File.size(a) == File.size(b)
    File.open(a, 'rb') {|fa|
      File.open(b, 'rb') {|fb|
        return compare_stream(fa, fb)
      }
    }
  end

  alias identical? compare_file
  alias cmp compare_file

  #
  # Options: noop verbose
  #
  # Changes permission bits on the named files (in +list+) to the bit pattern
  # represented by +mode+.
  #
  # +mode+ is the symbolic and absolute mode can be used.
  #
  # Absolute mode is
  #   FileUtils.chmod 0755, 'somecommand'
  #   FileUtils.chmod 0644, %w(my.rb your.rb his.rb her.rb)
  #   FileUtils.chmod 0755, '/usr/bin/ruby', :verbose => true
  #
  # Symbolic mode is
  #   FileUtils.chmod "u=wrx,go=rx", 'somecommand'
  #   FileUtils.chmod "u=wr,go=rr", %w(my.rb your.rb his.rb her.rb)
  #   FileUtils.chmod "u=wrx,go=rx", '/usr/bin/ruby', :verbose => true
  #
  #   "a" is user, group, other mask.
  #   "u" is user's mask.
  #   "g" is group's mask.
  #   "o" is other's mask.
  #   "w" is write permission.
  #   "r" is read permission.
  #   "x" is execute permission.
  #   "s" is uid, gid.
  #   "t" is sticky bit.
  #   "+" is added to a class given the specified mode.
  #   "-" Is removed from a given class given mode.
  #   "=" Is the exact nature of the class will be given a specified mode.

  def chmod(mode, list, options = {})
    fu_check_options options, OPT_TABLE['chmod']
    list = fu_list(list)
    fu_output_message sprintf('chmod %o %s', mode, list.join(' ')) if options[:verbose]
    return if options[:noop]
    list.each do |path|
      Entry_.new(path).chmod(fu_mode(mode, path))
    end
  end


  #
  # Options: noop verbose force
  #
  # Changes permission bits on the named files (in +list+)
  # to the bit pattern represented by +mode+.
  #
  #   FileUtils.chmod_R 0700, "/tmp/app.#{$$}"
  #   FileUtils.chmod_R "u=wrx", "/tmp/app.#{$$}"
  #
  def chmod_R(mode, list, options = {})
    fu_check_options options, OPT_TABLE['chmod_R']
    list = fu_list(list)
    fu_output_message sprintf('chmod -R%s %o %s',
                              (options[:force] ? 'f' : ''),
                              mode, list.join(' ')) if options[:verbose]
    return if options[:noop]
    list.each do |root|
      Entry_.new(root).traverse do |ent|
        begin
          ent.chmod(fu_mode(mode, ent.path))
        rescue
          raise unless options[:force]
        end
      end
    end
  end

  #
  # Options: noop verbose
  #
  # Changes owner and group on the named files (in +list+)
  # to the user +user+ and the group +group+.  +user+ and +group+
  # may be an ID (Integer/String) or a name (String).
  # If +user+ or +group+ is nil, this method does not change
  # the attribute.
  #
  #   FileUtils.chown 'root', 'staff', '/usr/local/bin/ruby'
  #   FileUtils.chown nil, 'bin', Dir.glob('/usr/bin/*'), :verbose => true
  #
  def chown(user, group, list, options = {})
    fu_check_options options, OPT_TABLE['chown']
    list = fu_list(list)
    fu_output_message sprintf('chown %s%s',
                              [user,group].compact.join(':') + ' ',
                              list.join(' ')) if options[:verbose]
    return if options[:noop]
    uid = fu_get_uid(user)
    gid = fu_get_gid(group)
    list.each do |path|
      Entry_.new(path).chown uid, gid
    end
  end


  #
  # Options: noop verbose force
  #
  # Changes owner and group on the named files (in +list+)
  # to the user +user+ and the group +group+ recursively.
  # +user+ and +group+ may be an ID (Integer/String) or
  # a name (String).  If +user+ or +group+ is nil, this
  # method does not change the attribute.
  #
  #   FileUtils.chown_R 'www', 'www', '/var/www/htdocs'
  #   FileUtils.chown_R 'cvs', 'cvs', '/var/cvs', :verbose => true
  #
  def chown_R(user, group, list, options = {})
    fu_check_options options, OPT_TABLE['chown_R']
    list = fu_list(list)
    fu_output_message sprintf('chown -R%s %s%s',
                              (options[:force] ? 'f' : ''),
                              [user,group].compact.join(':') + ' ',
                              list.join(' ')) if options[:verbose]
    return if options[:noop]
    uid = fu_get_uid(user)
    gid = fu_get_gid(group)
    return unless uid or gid
    list.each do |root|
      Entry_.new(root).traverse do |ent|
        begin
          ent.chown uid, gid
        rescue
          raise unless options[:force]
        end
      end
    end
  end

  #
  # Options: noop verbose
  #
  # Updates modification time (mtime) and access time (atime) of file(s) in
  # +list+.  Files are created if they don't exist.
  #
  #   FileUtils.touch 'timestamp'
  #   FileUtils.touch Dir.glob('*.c');  system 'make'
  #
  def touch(list, options = {})
    fu_check_options options, OPT_TABLE['touch']
    list = fu_list(list)
    created = nocreate = options[:nocreate]
    t = options[:mtime]
    if options[:verbose]
      fu_output_message "touch #{nocreate ? '-c ' : ''}#{t ? t.strftime('-t %Y%m%d%H%M.%S ') : ''}#{list.join ' '}"
    end
    return if options[:noop]
    list.each do |path|
      created = nocreate
      begin
        File.utime(t, t, path)
      rescue Errno::ENOENT
        raise if created
        File.open(path, 'a') {
          ;
        }
        created = true
        retry if t
      end
    end
  end

end
