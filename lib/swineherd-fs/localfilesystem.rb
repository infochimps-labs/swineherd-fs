module Swineherd
  class LocalFileSystem < FileSystem
    def initialize
      fs_uri = Java::java.net.URI.new("file:///")
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(fs_uri, @conf)
      super
    end
  end
end
