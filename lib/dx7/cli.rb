require 'unimidi'

module DX7
  class CLI
    def initialize
      @voice = Voice.default
      @output = UniMIDI::Output.gets if UniMIDI::Output.any?
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

      return if input == "\n"

      tokens = input.split

      op, key = nil, nil

      if tokens.size == 1
        op, key = @previous_command
      else
        if op?(tokens)
          op = tokens.shift.to_sym
        end
  
        if tokens.size != 2
          raise "invalid input: #{input.inspect}"
        end

        key = tokens.shift.to_sym
      end

      val = Integer(tokens.shift)

      raise 'no key' unless key
      raise 'no value' unless val

      @voice = op ? @voice.set_op(op, key, val, output: @output) : @voice.set(key, val, output: @output)
      @previous_command = [op, key]
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
