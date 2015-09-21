require 'fileutils'
require_relative 'trekky/context'

class Trekky
  @@locales = [""]

  def initialize(source_dir)
    @context = Context.new(source_dir)

    if File.exists?(config_file)
      STDOUT.puts "Loading config file: #{config_file}"
      require config_file
    end
  end

  def self.locales
    @@locales
  end
  def self.locales=(value)
    @@locales = value
  end

  def render_to(target_dir)
    target_dir = Pathname.new(target_dir).expand_path

    Trekky.locales.each{ |locale| 
      ENV['locale'] = locale.to_s
      @context.each_source do |source|
        current_target_dir = target_dir
        current_target_dir += locale.to_s + "/" if type = source.type and locale != ""
        path = target_path(current_target_dir, source)
        output = source.render
        output = source.render_errors unless source.valid?
        STDOUT.puts "Writing #{source.path} to #{path}"
        write(output, path)
      end
    }
  end

  private

  def target_path(target_dir, source)
    path = File.join(target_dir, source.path.to_s.gsub(@context.source_dir.to_s, ''))
    if type = source.type
      path.gsub(/\.#{type}/, '')
    else
      path
    end
  end

  def write(output, path)
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, "wb") {|f| f.write(output) }
  end

  def config_file
    File.join(Dir.pwd, "config.rb")
  end

end
