module Swineherd
  class LocalFileSystem < FileSystem
    def initialize *args
      fs_uri = Java::java.net.URI.new("file:///")
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(fs_uri, @conf)
      init_parent *args
    end
  end
end
