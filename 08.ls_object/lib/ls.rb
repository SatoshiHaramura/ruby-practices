# frozen_string_literal: true

module Command
  class Ls
    private attr_reader :files, :format # rubocop:disable Style/AccessModifierDeclarations

    def initialize(options, terminal_width)
      dot_match = options['a'] ? File::FNM_DOTMATCH : 0
      files_name = Dir.glob('*', dot_match)

      files_name = files_name.reverse if options['r']

      @files = files_name.map { |filename| Storage::File.new(filename) }

      @format = options['l'] ? LongFormat.new(files) : ShortFormat.new(files_name, terminal_width)
    end

    def execute
      format.render(files)
    end
  end
end
