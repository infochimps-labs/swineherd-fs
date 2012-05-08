require 'java'
require 'open-uri'

module Swineherd
  class FileSystem

    class HadoopPath
      def initialize child, fstype, host, path = ''
        @child = child
        @fstype = fstype
        @host = host
        @path_prefix = path
      end

      def glob path
        @child.glob "#{@fstype}://#{@host + File.join(@path_prefix, path)}"
      end

      def to_s
        return "#{@fstype}://#{@host}#{@path_prefix}"
      end
      
    end

    def initialize *args
      @conf = Java::org.apache.hadoop.conf.Configuration.new

      if Swineherd.config[:aws]
        @conf.set("fs.s3.awsAccessKeyId",Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])

        @conf.set("fs.s3n.awsAccessKeyId",Swineherd.config[:aws][:access_key])
        @conf.set("fs.s3n.awsSecretAccessKey",Swineherd.config[:aws][:secret_key])
      end

      @filesystems = {}
    end

    def getfs path
      uri = Java::java.net.URI.new path
      @filesystems[path] ||= Java::org.apache.hadoop.fs.FileSystem.get(uri,
                                                                       @conf)
    end
    
    def glob glob, default_fstype = 'file'
      path_components = %r{
        ^(?:(?<fstype>s3n?|hdfs|file):\/\/
            (?<host>[^\/]*))?
         (?<path>(?:\/.*)?)$
      }x

      m = path_components.match glob

      if m[:path]
        uri = Java::org.apache.hadoop.fs.Path.new m[:path]
        fs = getfs "#{m[:fstype] || default_fstype}://#{m[:host]}"
        files = fs.glob_status uri
        (files || []).map do |f|
          m = path_components.match f.get_path.to_s
          HadoopPath.new(self,
                         m[:fstype] || default_fstype,
                         m[:host] || '',
                         m[:path] || '')
        end
      else
        [Delegator.new(self,
                       "#{fstype}://#{host}",
                       fstype || default_fstype,
                       host || '')]
      end
    end

  end
end
