module DX7
  class CLI
    def initialize
      @voice = Voice.default
    end

    def run
      loop do
        render
        handle_input
      end
    end

    def render
      puts
      puts @voice
      print "\n> "
    end

    def handle_input
      input = read_line
      if input.nil?
        puts "\nBye!"
        exit
      end

      tokens = input.split
      op = nil
      if op?(tokens)
        op = tokens.shift.to_sym
      end

      if tokens.size != 2
        raise "invalid input: #{input.inspect}"
      end

      key, val = tokens[0].to_sym, Integer(tokens[1])
      @voice = op ? @voice.set_op(op, key, val) : @voice.set(key, val)
    rescue => ex
      puts "\nERROR: #{ex}"
    end

    def read_line
      loop do
        begin
          return gets
        rescue Interrupt
          return "\n"
        end
      end
    end

    def op?(tokens)
      %w[op1 op2 op3 op4 op5 op6].include?(tokens.first)
    end
  end
end
