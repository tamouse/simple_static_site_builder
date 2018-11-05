require "test_helper"
require "simple_static_site_builder/process_dir"

class SimpleStaticSiteBuilderTest < Minitest::Test
  def test_segment_types_creates_two_segments
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      processor = SimpleStaticSiteBuilder::ProcessDir.new(dir)
      segments = processor.segment_types
      assert segments.keys.sort == %i[directories files], segments.keys.sort
    end
  end
  def test_segment_types_files
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      processor = SimpleStaticSiteBuilder::ProcessDir.new(dir)
      segments = processor.segment_types
      assert segments[:files].sort == %w[granite.jpg netscape.jpg rose.jpg wizard.jpg], segments[:files].sort
    end
  end
  def test_segment_types_directories
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      processor = SimpleStaticSiteBuilder::ProcessDir.new(dir)
      segments = processor.segment_types
      assert segments[:directories].sort == %w[a b c], segments[:directories].sort
    end
  end

  def test_anchor_tag_easy
    processor = SimpleStaticSiteBuilder::ProcessDir.new
    name = "image.jpg"
    tag = processor.anchor_tag(name)
    assert_equal '<a href="image.jpg">image.jpg</a>', tag
  end

  def test_ancho_tag_hard
    processor = SimpleStaticSiteBuilder::ProcessDir.new
    name = "some>dank<baD%file.name"
    tag = processor.anchor_tag(name)
    assert_equal '<a href="some%3Edank%3CbaD%25file.name">some&gt;dank&lt;baD%file.name</a>', tag
  end


end
