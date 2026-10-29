# gem-publish_test.rb

# 20261029

# Run as a subprocess in a temporary directory holding no gemspec, so whatever it
# is given there's nothing it could build or push.  A file with restrictive
# permissions stands in for the directory's contents, so as a run which got as far
# as building would show by having opened them up.

require 'fileutils'
require 'minitest/autorun'
require 'rbconfig'
require 'tmpdir'

# GEM_PUBLISH points the suite at another revision.
TOOL = ENV['GEM_PUBLISH'] || File.expand_path('../bin/gem-publish', __dir__)

describe "gem-publish" do
  before do
    @root = Dir.mktmpdir('gem-publish')
    @file = File.join(@root, 'notes.txt')
    File.write(@file, '')
    File.chmod(0600, @file)
  end

  after do
    FileUtils.remove_entry(@root)
  end

  def run_gem_publish(*arguments)
    output = IO.popen([RbConfig.ruby, TOOL, *arguments], chdir: @root, in: File::NULL, err: [:child, :out], &:read)
    [output, $?.exitstatus]
  end

  def assert_untouched
    _(Dir.children(@root)).must_equal ['notes.txt']
    _(File.stat(@file).mode & 0777).must_equal 0600
  end

  describe "--help" do
    it "prints the usage and exits 0, touching nothing" do
      output, status = run_gem_publish('--help')
      _(status).must_equal 0
      _(output).must_include 'Usage: gem-publish [directory ...]'
      _(output).wont_include 'Nothing built or pushed'
      assert_untouched
    end

    it "is taken as -h too" do
      output, status = run_gem_publish('-h')
      _(status).must_equal 0
      _(output).must_include 'Usage: gem-publish [directory ...]'
      assert_untouched
    end

    it "wins over the directories beside it" do
      output, status = run_gem_publish('.', '--help')
      _(status).must_equal 0
      _(output).must_include 'Usage: gem-publish [directory ...]'
      _(output).wont_include 'No gemspec.'
      assert_untouched
    end
  end

  describe "an unknown switch" do
    it "prints the usage and exits 1, touching nothing" do
      output, status = run_gem_publish('--bogus')
      _(status).must_equal 1
      _(output).must_include 'Unknown switch: --bogus'
      _(output).must_include 'Usage: gem-publish [directory ...]'
      _(output).wont_include 'No such directory.'
      assert_untouched
    end

    it "is refused before the directories beside it are checked" do
      output, status = run_gem_publish('.', '-x')
      _(status).must_equal 1
      _(output).must_include 'Unknown switch: -x'
      _(output).wont_include 'No gemspec.'
      assert_untouched
    end
  end

  describe "a directory" do
    it "reaches the cleanliness check" do
      output, status = run_gem_publish('.')
      _(status).must_equal 1
      _(output).must_include 'Nothing built or pushed.'
      _(output).must_include 'No gemspec.'
      assert_untouched
    end

    it "is the current one where none is named" do
      output, status = run_gem_publish
      _(status).must_equal 1
      _(output).must_include 'No gemspec.'
      assert_untouched
    end

    it "is refused where it doesn't exist" do
      output, status = run_gem_publish('missing')
      _(status).must_equal 1
      _(output).must_include 'No such directory.'
      assert_untouched
    end
  end
end
