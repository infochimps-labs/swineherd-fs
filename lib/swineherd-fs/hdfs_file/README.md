
### Methods from the org.apache.hadoop.fs.FileSystem class

From [org.apache.hadoop.fs.FileSystem v1.0 docs](http://hadoop.apache.org/common/docs/current/api/org/apache/hadoop/fs/FileSystem.html)

> An abstract base class for a fairly generic filesystem. It may be implemented as a distributed filesystem, or as a "local" one that reflects the locally-connected disk. The local version exists for small Hadoop instances and for testing.
>
> All user code that may potentially use the Hadoop Distributed File System should be written to use a FileSystem object. The Hadoop DFS is a multi-machine system that appears as a single disk. It's useful because of its fault tolerance and potentially very large capacity.
> 
> The local implementation is LocalFileSystem and distributed implementation is DistributedFileSystem.


* [DistributedFileSystem](http://hadoop.apache.org/hdfs/docs/current/api/org/apache/hadoop/hdfs/DistributedFileSystem.html)


copy, copyMerge -- src/core/org/apache/hadoop/fs/FileUtil.java 

        abstract  boolean                        	rename(Path src, Path dst)                                                                                                                       	-- Renames Path src to Path dst.


        static void                              	addFileSystemForTesting(URI uri, Configuration conf, FileSystem fs)                                                                              	-- This method adds a file system for testing so that we can find it later.
        FSDataOutputStream                       	append(Path f)                                                                                                                                   	-- Append to an existing file (optional operation).
        protected  void                          	checkPath(Path path)                                                                                                                             	-- Check that a Path belongs to this FileSystem.
        static void                              	clearStatistics()                                                                                                                                	--  

        static FSDataOutputStream                	create(FileSystem fs, Path file, FsPermission permission)                                                                                        	-- create a file with the provided permission The permission of the file is set to be the provided permission as in setPermission, not permission&~umask It is implemented using two RPCs.
        
        void                                     	close()                                                                                                                                          	-- No more filesystem operations are needed.
        void                                     	copyFromLocalFile(boolean delSrc, boolean overwrite, Path[] srcs, Path dst)                                                                      	-- The src files are on the local disk.
        void                                     	copyToLocalFile(boolean delSrc, Path src, Path dst)                                                                                              	-- The src file is under FS, and the dst is on the local disk.
        abstract  boolean                        	delete(Path f, boolean recursive)                                                                                                                	-- Delete a file.


        static FileSystem                        	get(URI uri, Configuration conf, String user)                                                                                                    	--  
        static List<FileSystem.Statistics>       	getAllStatistics()                                                                                                                               	-- Return the FileSystem classes that have Statistics
        String                                   	getCanonicalServiceName()                                                                                                                        	-- Get a canonical service name for this file system.
        protected  URI                           	getCanonicalUri()                                                                                                                                	-- Resolve the uri's hostname and add the default port if not in the uri
        ContentSummary                           	getContentSummary(Path f)                                                                                                                        	-- Return the ContentSummary of a given Path.
        long                                     	getDefaultBlockSize()                                                                                                                            	-- Return the number of bytes that large input files should be optimally be split into to minimize i/o time.
        protected  int                           	getDefaultPort()                                                                                                                                 	-- Get the default port for this file system.
        short                                    	getDefaultReplication()                                                                                                                          	-- Get the default replication.
        static URI                               	getDefaultUri(Configuration conf)                                                                                                                	-- Get the default filesystem URI from a configuration.
        Token<?>                                 	getDelegationToken(String renewer)                                                                                                               	-- Get a new delegation token for this file system.
        BlockLocation[]                          	getFileBlockLocations(FileStatus file, long start, long len)                                                                                     	-- Return an array containing hostnames, offset and size of portions of the given file.
        FileChecksum                             	getFileChecksum(Path f)                                                                                                                          	-- Get the checksum of a file.
        abstract  FileStatus                     	getFileStatus(Path f)                                                                                                                            	-- Return a file status object that represents the path.
        static FileSystem.Statistics             	getStatistics(String scheme, Class<? extends FileSystem> cls)                                                                                    	-- Get the statistics for a particular file system
        abstract  URI                            	getUri()                                                                                                                                         	-- Returns a URI whose scheme and authority identify this FileSystem.
        void                                     	concat(oah.fs.Path trg, oah.fs.Path[] psrcs)                                                                                                     	-- THIS IS DFS only operations, it is not part of FileSystem move blocks from srcs to trg and delete srcs afterwards all blocks should be the same size
        long                                     	getCorruptBlocksCount()                                                                                                                          	-- Returns count of blocks with at least one replica marked corrupt.
        DatanodeInfo[]                           	getDataNodeStats()                                                                                                                               	-- Return statistics for each datanode.
        long                                     	getMissingBlocksCount()                                                                                                                          	-- Returns count of blocks with no good replicas left.
        oah.fs.FsServerDefaults                  	getServerDefaults()                                                                                                                              	-- 
        oah.fs.FsStatus                          	getStatus(oah.fs.Path p)                                                                                                                         	-- 

        FileStatus[]                             	globStatus(Path pathPattern, PathFilter filter)                                                                                                  	-- Return an array of FileStatus objects whose path names match pathPattern and is accepted by the user-supplied path filter.
        
        static void                              	closeAll()                                                                                                                                       	-- Close all cached filesystems.
        static void                              	closeAllForUGI(UserGroupInformation ugi)                                                                                                         	-- Close all cached filesystems for a given UGI.
        void                                     	completeLocalOutput(Path fsOutputFile, Path tmpLocalFile)                                                                                        	-- Called when we're all done writing to the target.
        boolean                                  	createNewFile(Path f)                                                                                                                            	-- Creates the given Path as a brand-new zero-length file.
        boolean                                  	deleteOnExit(Path f)                                                                                                                             	-- Mark a path to be deleted when FileSystem is closed.
        boolean                                  	exists(Path f)                                                                                                                                   	-- Check if exists.
        Path                                     	getHomeDirectory()                                                                                                                               	-- Return the current user's home directory in this filesystem.

        void                                     	setOwner(oah.fs.Path p, String username, String groupname)                                                                                       	-- 
        void                                     	setPermission(oah.fs.Path p, oah.fs.permission.FsPermission permission)                                                                          	-- 
        boolean                                  	setReplication(oah.fs.Path src, short replication)                                                                                               	-- 
        
        static LocalFileSystem                   	getLocal(Configuration conf)                                                                                                                     	-- Get the local file syste
        long                                     	getUsed()                                                                                                                                        	-- Return the total size of all files in the filesystem.
        void                                     	initialize(URI name, Configuration conf)                                                                                                         	-- Called after a new FileSystem instance is constructed.
        boolean                                  	isFile(Path f)                                                                                                                                   	-- True iff the named path is a regular file.
        FileStatus[]                             	listStatus(Path f, PathFilter filter)                                                                                                            	-- Filter files/directories in the given path using the user-supplied path filter.
        Path                                     	makeQualified(Path path)                                                                                                                         	-- Make sure that a path specifies a FileSystem.
        static boolean                           	mkdirs(FileSystem fs, Path dir, FsPermission permission)                                                                                         	-- create a directory with the provided permission The permission of the directory is set to be the provided permission as in setPermission, not permission&~umask
        void                                     	moveFromLocalFile(Path[] srcs, Path dst)                                                                                                         	-- The src files is on the local disk.
        void                                     	moveToLocalFile(Path src, Path dst)                                                                                                              	-- The src file is under FS, and the dst is on the local disk.
        abstract  FSDataInputStream              	open(Path f, int bufferSize)                                                                                                                     	-- Opens an FSDataInputStream at the indicated Path.
        static void                              	printStatistics()                                                                                                                                	--  
        protected  void                          	processDeleteOnExit()                                                                                                                            	-- Delete all files that were marked as delete-on-exit.
        static void                              	setDefaultUri(Configuration conf, URI uri)                                                                                                       	-- Set the default filesystem URI in a configuration.
        void                                     	setOwner(Path p, String username, String groupname)                                                                                              	-- Set owner of a path (i.e.
        void                                     	setPermission(Path p, FsPermission permission)                                                                                                   	-- Set permission of a path.
        boolean                                  	setReplication(Path src, short replication)                                                                                                      	-- Set replication for an existing file.
        void                                     	setTimes(Path p, long mtime, long atime)                                                                                                         	-- Set access time of a file
        void                                     	setVerifyChecksum(boolean verifyChecksum)                                                                                                        	-- Set the verify checksum flag.
        abstract  void                           	setWorkingDirectory(Path new_dir)                                                                                                                	-- Set the current working directory for the given file system.
        Path                                     	startLocalOutput(Path fsOutputFile, Path tmpLocalFile)                                                                                           	-- Returns a local File that the user can write output to.

        void                                     	cancelDelegationToken(oah.security.token.Token<DelegationTokenIdentifier> token)                                                                 	-- Cancel an existing delegation token.
        protected  void                          	checkPath(oah.fs.Path path)                                                                                                                      	-- Permit paths which explicitly specify the default port.
        UpgradeStatusReport                      	distributedUpgradeProgress(FSConstants.UpgradeAction action)                                                                                     	-- 
        void                                     	finalizeUpgrade()                                                                                                                                	-- Finalize previously upgraded files system state.
        DFSClient                                	getClient()                                                                                                                                      	-- 
        long                                     	getUnderReplicatedBlocksCount()                                                                                                                  	-- Returns count of blocks with one of more replica missing.
        protected  ...RemoteIterator<>           	listLocatedStatus(oah.fs.Path p, oah.fs.PathFilter filter)                                                                                       	-- 
        void                                     	metaSave(String pathname)                                                                                                                        	-- 
        boolean                                  	recoverLease(oah.fs.Path f)                                                                                                                      	-- Start the lease recovery of a file
        void                                     	refreshNodes()                                                                                                                                   	-- Refreshes the list of hosts and excluded hosts from the configured files.
        long                                     	renewDelegationToken(oah.security.token.Token<DelegationTokenIdentifier> token)                                                                  	-- Renew an existing delegation token.
        boolean                                  	reportChecksumFailure(oah.fs.Path f, oah.fs.FSDataInputStream in, long inPos, oah.fs.FSDataInputStream sums, long sumsPos)                       	-- We need to find the blocks that didn't match.
        boolean                                  	restoreFailedStorage(String arg)                                                                                                                 	-- enable/disable/check restoreFaileStorage
        void                                     	saveNamespace()                                                                                                                                  	-- Save namespace image.
        void                                     	setQuota(oah.fs.Path src, long namespaceQuota, long diskspaceQuota)                                                                              	-- Set a directory's quotas
        boolean                                  	setSafeMode(FSConstants.SafeModeAction action)                                                                                                   	-- Enter, leave or get safe mode.
        void                                     	setTimes(oah.fs.Path p, long mtime, long atime)                                                                                                  	-- 
        void                                     	setVerifyChecksum(boolean verifyChecksum)                                                                                                        	-- 
        void                                     	setWorkingDirectory(oah.fs.Path dir)                                                                                                             	-- 
        abstract  Path                           	getWorkingDirectory()                                                                                                                            	-- Get the current working directory for the given file system
        String                                   	toString() 

        
