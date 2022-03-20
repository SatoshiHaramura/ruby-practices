# frozen_string_literal: true

class LongFormat
  private attr_reader :total_block_size, :max_length_map # rubocop:disable Style/AccessModifierDeclarations

  def initialize(files)
    @total_block_size = calculate_total_block_size(files)
    @max_length_map = build_max_length_map(files)
  end

  def render(files)
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

  private

  def calculate_total_block_size(files)
    files.map { |file| file.detail_info[:blocks] }.sum
  end

  def build_max_length_map(files)
    {
      link: files.map { |file| file.detail_info[:link].length }.max,
      owner: files.map { |file| file.detail_info[:owner].length }.max,
      group: files.map { |file| file.detail_info[:group].length }.max,
      size: files.map { |file| file.detail_info[:size].length }.max
    }
  end

  def export_symlink_name(name)
    "#{name} -> #{File.readlink(name)}"
  end
end
