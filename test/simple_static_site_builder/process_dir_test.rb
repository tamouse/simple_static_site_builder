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

  def test_list_item
    processor = SimpleStaticSiteBuilder::ProcessDir.new
    entry = "something"
    actual = processor.list_item(entry)
    assert_equal "<li>something</li>", actual
  end

  def test_build_list
    processor = SimpleStaticSiteBuilder::ProcessDir.new
    entries = %w[one two three]
    actual = processor.build_list(entries)
    assert_equal "<ul><li><a href=\"one\">one</a></li><li><a href=\"two\">two</a>" +
                 "</li><li><a href=\"three\">three</a></li></ul>", actual

  end

  def test_build_index
    processor = SimpleStaticSiteBuilder::ProcessDir.new
    segments = {
      files: %w[one.fish two.fish],
      directories: %w[red blue]
    }
    expected = <<-EOF
<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <title>.</title>
  </head>
  <body>
    <header>
      <h1>.</h1>
      <h2>Directories</h2>
      <ul><li><a href=\"red\">red</a></li><li><a href=\"blue\">blue</a></li></ul>
      <h2>Files</h2>
      <ul><li><a href=\"one.fish\">one.fish</a></li><li><a href=\"two.fish\">two.fish</a></li></ul>

      <hr />
      <p><a href=\"../\">Up</a></p>
    </header>
  </body>
</html>
EOF
    actual = processor.build_index(segments)
    assert_equal expected, actual
  end

  def test_run
    run_in_tmpdir do |dir|
      copy_test_data(dir)
      processor = SimpleStaticSiteBuilder::ProcessDir.new(dir)
      result = processor.run
      assert File.exists?("index.html")
      actual = File.read("index.html")
      expected = <<-EOF
<!DOCTYPE html>
<html>
  <head>
    <meta charset=\"utf-8\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">
    <title>#{dir}</title>
  </head>
  <body>
    <header>
      <h1>#{dir}</h1>
      <h2>Directories</h2>
      <ul><li><a href=\"a\">a</a></li><li><a href=\"b\">b</a></li><li><a href=\"c\">c</a></li></ul>
      <h2>Files</h2>
      <ul><li><a href=\"granite.jpg\">granite.jpg</a></li><li><a href=\"netscape.jpg\">netscape.jpg</a></li><li><a href=\"rose.jpg\">rose.jpg</a></li><li><a href=\"wizard.jpg\">wizard.jpg</a></li></ul>

      <hr />
      <p><a href=\"../\">Up</a></p>
    </header>
  </body>
</html>
EOF
      assert_equal expected, actual

      assert_equal %i[directories files], result.segments.keys.sort
      assert_equal %w[a b c], result.segments[:directories].sort
      assert_equal %w[granite.jpg netscape.jpg rose.jpg wizard.jpg], result.segments[:files].sort

      expected_indexes = %w[index.html a/index.html b/index.html c/index.html].map{|d| File.join(dir, d)}.sort
      actual_indexes = Dir[File.join(dir, '**', 'index.html')].sort
      assert_equal expected_indexes, actual_indexes
    end
  end
end
