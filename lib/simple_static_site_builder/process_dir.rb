require "erb"
require "uri"

module SimpleStaticSiteBuilder
  class ProcessDir
    attr_reader :dir

    def initialize(dir = '.')
      @dir = dir
    end

    # return an hash of arrays, with a hash entry for each type of entry, e.g. `file`, `directory`
    def segment_types
      segments = {
        files: [],
        directories: []
      }
      Dir.chdir(dir) do
        Dir['*'].reduce(segments) do |h, entry|
          if File.directory? entry
            h[:directories].push entry
          elsif File.file? entry
            h[:files].push entry
          end
          h
        end
      end
    end

    def anchor_tag(entry)
      href = URI.encode entry
      text = ERB::Util.h entry
      "<a href=\"#{href}\">#{text}</a>"
    end


  end
end
