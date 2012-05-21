module Swineherd
  class HadoopFileSystem < FileSystem
    def initialize
      @filesystem = Java::org.apache.hadoop.fs.FileSystem.get(@conf)
      super
    end
  end
end
