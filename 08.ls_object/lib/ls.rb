# frozen_string_literal: true

MAX_COLUMNS = 3
FILENAME_LENGTH_UNIT = 8

module Command
  class Ls
    attr_reader :files
    private attr_reader :options, :files_name, :max_filename_length, :columns, :rows # rubocop:disable Style/AccessModifierDeclarations

    def initialize(options, terminal)
      @options = options
      @files_name = options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
      @files_name = files_name.reverse if options['r']

      @max_filename_length = calculate_max_filename_length
      @columns = calculate_columns_of_short_format(terminal)
      @rows = calculate_rows_of_short_format
    end

    def execute
      @files = files_name.map { |filename| Storage::File.new(filename) }
      @files.each(&:build_detail_info) if options['l']
      options['l'] ? render_long_format(calculate_total_block_size, build_max_length_map) : render_short_format
    end

    private

    def calculate_max_filename_length
      FILENAME_LENGTH_UNIT * ((files_name.map(&:length).max / FILENAME_LENGTH_UNIT) + 1)
    end

    def calculate_columns_of_short_format(terminal)
      return MAX_COLUMNS if max_filename_length * MAX_COLUMNS < terminal.width

      1.upto(MAX_COLUMNS) do |column|
        break column if terminal.width < max_filename_length * (column + 1)
      end
    end

    def calculate_rows_of_short_format
      (files_name.count.to_f / columns).ceil(0)
    end

    def render_short_format
      str = []
      rows.times do |r|
        columns.times do |c|
          index = rows * c + r
          next unless files[index]

          str << files[index].name.ljust(max_filename_length)
        end
        str[-1] = str[-1].rstrip
        str << "\n"
      end
      str
    end

    def calculate_total_block_size
      files.map { |file| file.detail_info[:blocks] }.sum
    end

    def build_max_length_map
      {
        link: files.map { |file| file.detail_info[:link].length }.max,
        owner: files.map { |file| file.detail_info[:owner].length }.max,
        group: files.map { |file| file.detail_info[:group].length }.max,
        size: files.map { |file| file.detail_info[:size].length }.max
      }
    end

    def render_long_format(total_block_size, max_length_map)
      files.each_with_object(["total #{total_block_size}\n"]) do |file, str|
        str << [
          file.detail_info[:type],
          "#{file.detail_info[:permission]} ",
          "#{file.detail_info[:link].rjust(max_length_map[:link] + 1)} ",
          "#{file.detail_info[:owner].ljust(max_length_map[:owner])}  ",
          "#{file.detail_info[:group].ljust(max_length_map[:group])} ",
          "#{file.detail_info[:size].rjust(max_length_map[:size] + 1)} ",
          "#{file.detail_info[:month].rjust(2)} ",
          "#{file.detail_info[:day].rjust(2)} ",
          "#{file.detail_info[:time]} ",
          (file.detail_info[:type] == 'l' ? export_symlink_name(file.name) : file.name),
          "\n"
        ].join
      end
    end

    def export_symlink_name(name)
      "#{name} -> #{File.readlink(name)}"
    end
  end
end
