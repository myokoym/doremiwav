require "optparse"
require "mml2wav/version"
require "mml2wav/wave"

module Mml2wav
  class Command
    def self.run(arguments)
      new(arguments).run
    end

    def initialize(arguments)
      @options = parse_options(arguments)
      @sounds = ARGF.readlines.join(" ")
    end

    def run
      Wave.write(@sounds, @options)
    end

    private
    def parse_options(arguments)
      options = {}

      parser = OptionParser.new("#{$0} INPUT_FILE")
      parser.version = VERSION

      parser.on("--output=FILE", "Specify output file path") do |path|
        options[:output] = path
      end
      parser.on("--sampling_rate=RATE",
                "Specify sampling rate", Integer) do |rate|
        options[:sampling_rate] = rate
      end
      parser.parse!(arguments)

      unless File.pipe?('/dev/stdin') || IO.select([ARGF], nil, nil, 0)
        puts(parser.help)
        exit(true)
      end

      options
    end
  end
end
