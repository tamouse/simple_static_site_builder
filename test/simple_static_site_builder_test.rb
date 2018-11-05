require "test_helper"

class SimpleStaticSiteBuilderTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::SimpleStaticSiteBuilder::VERSION
  end

  def test_that_it_creates_test_dir
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      assert Dir.exist?(dir), dir
    end
  end

  def test_that_temp_dir_is_removed
    run_in_tmpdir do |dir|
      @test_dir = dir
      assert Dir.exist?(dir), dir
    end
    refute Dir.exist?(@test_dir)
  end

  def test_that_it_creates_test_subdirz
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      assert Dir.exist?(File.join(dir, "a")), Dir['**/*'].join("\n")
      assert Dir.exist?(File.join(dir, "b")), Dir['**/*'].join("\n")
      assert Dir.exist?(File.join(dir, "c")), Dir['**/*'].join("\n")
    end
  end

  def test_that_it_creates_test_files
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      assert File.exist?(File.join(dir, "granite.jpg")), Dir['**/*'].join("\n")
      assert File.exist?(File.join(dir, "netscape.jpg")), Dir['**/*'].join("\n")
      assert File.exist?(File.join(dir, "rose.jpg")), Dir['**/*'].join("\n")
      assert File.exist?(File.join(dir, "wizard.jpg")), Dir['**/*'].join("\n")
    end
  end
end
