module Swineherd
  class S3FileSystem < FileSystem
    def initialize *args
      @filesystems = {}
      init_parent *args
    end

    # FIXME: Considering a bucket part of a path is creating all kinds
    # of trouble. A get_path will have to be constructed to extract
    # the bucket name from a path, or we'll have to adopt the
    # convention used by the Hadoop FileSystem api and map filesystems
    # to buckets. The latter is a much cleaner option.
    def get_fs path
      %r{
            (?:(?<protocol>s3n?):\/\/)?
            (?<bucket>[^\/]*)
            (?<fs_path>\/.*$)
        }x =~ path.to_s

      # ignore user-specified protocol, if any
      protocol = type.to_s

      uri = Java::java.net.URI.new("#{protocol}://#{bucket}")
      @filesystems[uri] ||= Java::org.apache.hadoop.fs.FileSystem.get(uri,
                                                                      @conf)
    end
  end
end
