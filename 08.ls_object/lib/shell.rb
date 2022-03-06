# frozen_string_literal: true

module Os
  class Shell
    def request_execution(command)
      kernel.execute(command)
    end

    private

    def kernel
      Os::Kernel.new
    end
  end
end
