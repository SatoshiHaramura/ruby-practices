# frozen_string_literal: true

require 'io/console'

class Terminal
  attr_reader :width
  private attr_reader :command # rubocop:disable Style/AccessModifierDeclarations

  def initialize(width = IO.console.winsize[1])
    @width = width
  end

  def accept_command(options)
    @command = Command::Ls.new(options, self)
  end

  def deliver
    result = shell.request_execution(command)
    render(result)
  end

  private

  def shell
    Os::Shell.new
  end

  def render(result)
    result.inject { |res, str| res + str }
  end
end
