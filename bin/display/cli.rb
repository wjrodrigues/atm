# frozen_string_literal: true

module Display
  class CLI
    attr_accessor :kernel
    private :kernel=

    def initialize(kernel: Kernel)
      self.kernel = kernel
    end

    def clear = kernel.system('clear')

    def write(msg) = kernel.puts(msg)

    def close = kernel.exit

    def read = kernel.gets
  end
end
