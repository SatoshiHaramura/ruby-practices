# frozen_string_literal: true

module Command
  class Ls
    private attr_reader :options, :files_name, :short_format # rubocop:disable Style/AccessModifierDeclarations

    def initialize(options, terminal_width)
      @options = options

      dot_match = options['a'] ? File::FNM_DOTMATCH : 0
      @files_name = Dir.glob('*', dot_match)

      @files_name = files_name.reverse if options['r']

      @short_format = ShortFormat.new(files_name, terminal_width)
    end

    def execute
      files = files_name.map { |filename| Storage::File.new(filename) }

      files.each(&:build_detail_info) if options['l']
      format = options['l'] ? LongFormat.new(files) : short_format

      format.render(files)
    end
  end
end
