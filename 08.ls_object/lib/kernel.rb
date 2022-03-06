# frozen_string_literal: true

module Os
  class Kernel
    def execute(command)
      command.execute
    end
  end
end
