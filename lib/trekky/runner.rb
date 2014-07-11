require 'fileutils'
require 'trekky/haml_parser'
require 'trekky/sass_parser'

module Trekky

  class Runner

    attr_reader :source_dir, :target_dir

    PARSERS = {
      :sass => SassParser,
      :haml => HamlParser
    }

    def initialize(source_dir, target_dir)
      @source_dir = source_dir
      @target_dir = target_dir
    end

    def run(sources = default_sources)
      sources.each do |source|
        input = File.read(source)
        target = source.gsub(source_dir, target_dir)
        extension = File.extname(source)[1..-1].intern
        output = if parser = PARSERS[extension]
          target.gsub!(/\.#{extension}/, '')
          parser.new(input, source_dir, target_dir).output
        else
          input
        end
        STDOUT.puts "-> #{source} to #{target}"
        write output, target
      end
    end

    private

    def write(output, target)
      FileUtils.mkdir_p(File.dirname(target))
      File.open(target, "wb") {|f| f.write(output) }
    end

    def default_sources
      Dir.glob(File.join(source_dir, "**/*")).
        reject do |p|
          p.include?("#{source_dir}/layouts") ||
          File.directory?(p)
        end
    end

  end
end
