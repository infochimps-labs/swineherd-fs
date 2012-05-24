module Swineherd
  class LocalFileSystem < FileSystem
    def initialize *args
      init_parent *args
      fs_uri = Java::java.net.URI.new("file:///")
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(fs_uri, @conf)
    end
  end
end
