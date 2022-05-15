# frozen_string_literal: true

MAX_COLUMNS = 3
FILENAME_LENGTH_UNIT = 8

class ShortFormat
  private attr_reader :filename_width, :columns, :rows # rubocop:disable Style/AccessModifierDeclarations

  def initialize(files_name, terminal_width)
    @filename_width = calculate_filename_width(files_name)
    @columns = calculate_columns(terminal_width)
    @rows = calculate_rows(files_name)
  end

  def render(files)
    str = []
    rows.times do |r|
      columns.times do |c|
        index = rows * c + r
        next unless files[index]

        str << files[index].name.ljust(filename_width)
      end
      str[-1] = str[-1].rstrip
      str << "\n"
    end
    str
  end

  private

  def calculate_filename_width(files_name)
    FILENAME_LENGTH_UNIT * ((files_name.map(&:length).max / FILENAME_LENGTH_UNIT) + 1)
  end

  def calculate_columns(terminal_width)
    return MAX_COLUMNS if filename_width * MAX_COLUMNS < terminal_width

    1.upto(MAX_COLUMNS) do |column|
      break column if terminal_width < filename_width * (column + 1)
    end
  end

  def calculate_rows(files_name)
    (files_name.count.to_f / columns).ceil(0)
  end
end
