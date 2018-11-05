require "erb"
require "uri"

module SimpleStaticSiteBuilder
  class ProcessDir
    attr_reader :dir, :segments, :index

    def initialize(dir = '.')
      @dir = dir
    end

    def run
      Dir.chdir(dir) do |dir|
        @segments = segment_types
        @index = build_index(segments)
        File.write("index.html", index)

        segments[:directories].each do |subdir|
          SimpleStaticSiteBuilder::ProcessDir.new(subdir).run
        end
      end
      self
    end

    # return an hash of arrays, with a hash entry for each type of entry, e.g. `file`, `directory`
    def segment_types
      segments = {
        files: [],
        directories: []
      }
      Dir['*'].reduce(segments) do |h, entry|
        if File.directory? entry
          h[:directories].push entry
        elsif File.file? entry
          h[:files].push entry
        end
        h
      end
    end

    def anchor_tag(entry)
      href = URI.encode entry
      text = ERB::Util.h entry
      "<a href=\"#{href}\">#{text}</a>"
    end

    def list_item(contents)
      "<li>#{contents}</li>"
    end

    def build_list(entries)
      entries.map do |entry|
        list_item(anchor_tag(entry))
      end.unshift("<ul>").push("</ul>").join()
    end

    def build_index(segments)
      template = File.read(File.expand_path("../index.html.erb", __FILE__))
      title = ERB::Util.h @dir
      directories_list = build_list(segments[:directories])
      files_list = build_list(segments[:files])

      b = binding
      ERB.new(template).result(b)
    end

  end
end
