module SimpleStaticSiteBuilder
  class CLI
    attr_reader :args, :options

    def initialize(*args)
      @args = args
      @options = process_args(@args)
    end

    def run

    end
  end
end
