module Swineherd
  class HadoopFileSystem < FileSystem
    def initialize *args
      init_parent *args
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(@conf)
    end
  end
end
