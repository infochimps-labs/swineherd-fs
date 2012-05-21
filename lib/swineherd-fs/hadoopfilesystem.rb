module Swineherd
  class HadoopFileSystem < FileSystem
    def initialize *args
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(@conf)
      init_parnet *args
    end
  end
end
