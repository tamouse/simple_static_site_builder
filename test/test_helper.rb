$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "simple_static_site_builder"
require "minitest/autorun"
require "tmpdir"
require "fileutils"
require "byebug"

def run_in_tmpdir(&b)
  Dir.mktmpdir() do |tmp_test_dir|
    Dir.chdir(tmp_test_dir) do |dir|
      yield dir
    end
  end
end

def copy_test_data(dest)
  template_dir = File.expand_path("../template", __FILE__)
  FileUtils.cp_r(File.join(template_dir, "."), dest)
end
