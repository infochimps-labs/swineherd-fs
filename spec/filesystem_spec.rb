require 'spec_helper'
FS_SPEC_ROOT = File.dirname(__FILE__)
S3_TEST_BUCKET = 'swineherd-fs-test-bucket' #You'll have to set this to something else

shared_examples_for "an abstract filesystem" do

  let(:test_filename){ File.join(test_dirname,"filename.txt") }
  let(:test_string){ "foobarbaz" }

  let(:files){ ['d.txt','b/c.txt'].map{|f| File.join(test_dirname,f)} }
  let(:dirs){ %w(b).map{|d| File.join(test_dirname,d)} }

  it "implements #exists?" do
    fs.mkdir_p(test_dirname)
    expect{ fs.open(test_filename,'w'){|f| f.write(test_string)} }.to change{ fs.exists?(test_filename) }.from(false).to(true)
  end

  it "implements #directory?" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename, 'w'){|f| f.write(test_string)}
    fs.directory?(test_filename).should eql false
    fs.directory?(test_dirname).should eql true
  end

  it "implements #rm on files" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename, 'w'){|f| f.write(test_string)}
    expect{ fs.rm(test_filename) }.to change{ fs.exists?(test_filename) }.from(true).to(false)
  end

  it "raises error on #rm of non-empty directory" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename, 'w'){|f| f.write(test_string)}
    expect{fs.rm(test_dirname)}.to raise_error
  end

  it "implements #rm_r" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename,'w'){|f| f.write(test_string)}
    expect{ fs.rm_r(test_dirname) }.to change{ fs.exists?(test_dirname) && fs.exists?(test_filename) }.from(true).to(false)
  end

  it "implements #ls" do
    dirs.each{ |dir| fs.mkdir_p(dir) }
    files.each{|filename| fs.open(filename,"w"){|f|f.write(test_string) }}
    fs.ls(test_dirname).length.should eql 2
  end

  it "implements #ls_r" do
    dirs.each{ |dir| fs.mkdir_p(dir) }
    files.each{|filename| fs.open(filename,"w"){|f|f.write(test_string) }}
    fs.ls_r(test_dirname).length.should eql 3
  end

  it "implements #size" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename,'w'){|f| f.write(test_string)}
    test_string.length.should eql(fs.size(test_filename))
  end

  it "implements #mkdir_p" do
    expect{ fs.mkdir_p(test_dirname) }.to change{ fs.directory?(test_dirname) }.from(false).to(true)
  end

  it "implements #mv" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename, 'w'){|f| f.write(test_string)}
    filename2 = File.join(test_dirname,"new_file.txt")
    expect{ fs.mv(test_filename, filename2) }.to change{ fs.exists?(filename2) }.from(false).to(true)
    fs.exists?(test_filename).should eql false
    fs.open(filename2,"r").read.should eql test_string
  end

  it "implements #cp" do
    fs.mkdir_p(test_dirname)
    fs.open(test_filename, 'w'){|f| f.write(test_string)}
    filename2 = File.join(test_dirname,"new_file.txt")
    expect{ fs.cp(test_filename, filename2) }.to change{ fs.exists?(filename2) }.from(false).to(true)
    fs.open(test_filename,"r").read.should eql fs.open(filename2,"r").read
  end

  it "implements #cp_r"

  it "implements #open" do
    fs.mkdir_p(test_dirname)
    expect{
      file = fs.open(test_filename, 'w')
      file.write(test_string)
      file.close
    }.to change{ fs.exists?(test_filename) }.from(false).to(true)
  end

  it "implements #open with &blk" do
    fs.mkdir_p(test_dirname)
    expect{ fs.open(test_filename, 'w'){|f| f.write(test_string)} }.to change{ fs.exists?(test_filename) }.from(false).to(true)
  end

  describe "with a new file" do

    it "implements path" do
      fs.mkdir_p(test_dirname)
      file = fs.open(test_filename,'w')
      file.path.should eql test_filename
    end

    it "implements write" do
      fs.mkdir_p(test_dirname)
      fs.open(test_filename,'w'){|f| f.write(test_string)}
    end

    it "should not allow write after close" do
      fs.mkdir_p(test_dirname)
      file = fs.open(test_filename,'w')
      file.write(test_string)
      file.close
      lambda{file.write(test_string)}.should raise_error
    end

    it "implements read" do
      fs.mkdir_p(test_dirname)
      fs.open(test_filename,'w'){|f| f.write(test_string)}
      fs.open(test_filename,'r').read.should eql test_string
    end

  end

  after do
    fs.rm_r(test_dirname) if fs.exists?(test_dirname)
  end

end

describe Swineherd::FileSystem do
  let(:fs){ Swineherd::FileSystem }
  let(:test_dirname){ FS_SPEC_ROOT+"/tmp/test_dir" }
  let(:test_filename){ File.join(test_dirname,"filename.txt") }
  let(:test_string){ "foobarbaz" }

  it "implements #cp" do
    localfs = Swineherd::LocalFileSystem.new
    s3_fs = Swineherd::S3FileSystem.new
    localfs.mkdir_p(test_dirname)
    localfs.open(test_filename, 'w'){|f| f.write(test_string)}
    s3_filename = "s3://"+S3_TEST_BUCKET+"/new_file.txt"
    expect{ fs.cp(test_filename, s3_filename) }.to change{ fs.exists?(s3_filename) }.from(false).to(true)
    localfs.rm_r(test_dirname) if localfs.exists?(test_dirname)
    s3_fs.rm(s3_filename)
  end
end

describe Swineherd::LocalFileSystem do

  it_behaves_like "an abstract filesystem" do
    let(:fs){ Swineherd::LocalFileSystem.new }
    let(:test_dirname){ FS_SPEC_ROOT+"/tmp/test_dir" }
  end

end

describe Swineherd::S3FileSystem do

  #mkdir_p won't pass because there is no concept of a directory on s3

  it_behaves_like "an abstract filesystem" do
    let(:fs){ Swineherd::S3FileSystem.new }
    let(:test_dirname){ S3_TEST_BUCKET+"/tmp/test_dir" }
  end

  describe "an S3FileSystem" do
    let(:fs){ Swineherd::S3FileSystem.new }

    it "should return false for #file? on a bucket" do
      fs.file?(S3_TEST_BUCKET).should eql false
    end

  end
end

describe Swineherd::HadoopFileSystem do

  it_behaves_like "an abstract filesystem" do
    let(:fs){ Swineherd::HadoopFileSystem.new }
    let(:test_dirname){ "/tmp/test_dir" }
  end

end
