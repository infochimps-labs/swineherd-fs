module Swineherd
  class S3FileSystem < FileSystem
    def initialize
      @filesystems = {}
      super
    end
    
    def get_fs path
      %r{
            (?:(?<protocol>s3n?):\/\/)?
            (?<bucket>[^\/]*)
            (?<fs_path>\/.*$)
        }x =~ path

      # ignore user-specified protocol, if any
      protocol = type.to_s

      fs_uri = Java::java.net.URI.new("#{protocol}://#{bucket}")
      [get_fs(fs_uri), fs_path]
      
      @filesystems[uri] ||= Java::org.apache.hadoop.fs.FileSystem.get(uri,
                                                                      @conf)
    end
  end
end
