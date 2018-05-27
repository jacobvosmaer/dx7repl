require_relative 'dx7/algorithms'
require_relative 'dx7/operator'
require_relative 'dx7/validations'

module DX7
  class Voice
    include Validations

    KEYS = %i[
      pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4
      als fbl opi lfs lfd lpmd pamd lfks lfw lpms trnp
      vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10
    ].freeze

    VALIDATIONS = {
      %i[pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4 lfs lfd lpmd pamd] => 0..99,
      %i[als] => 0..31,
      %i[fbl lpms] => 0..7,
      %i[opi lfks] => 0..1,
      %i[lfw] => 0..5,
      %i[trnp] => 0..48,
      %i[vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10] => 33..126,
    }

    LEGEND1 = 'Alg  Fbl  Osc.sync  Transpose    Voice name'.freeze
    LEGEND3 = 'Pitch EG     R1  R2  R3  R4  L1  L2  L3  L4'.freeze
    LEGEND2 = 'LFO Wave  Speed  Delay  Pmd  Amd  Pms  Sync'.freeze

    def initialize
      check_validations!
      @operators = 6.times.map { Operator.new }
      @data = Hash.new(0)
    end

    def to_s
      lines = []

      lines << ('      ' + Operator::LEGEND)
      @operators.each_with_index { |op, i| lines << "OP#{i+1}   #{op}" }
      lines << ''

      lines << ('      ' + LEGEND1 + '               ' + alg_art[0])
      lines << sprintf(
        '       %2d   %2d       %3s         %2s    %10s               %s',
        @data[:als]+1, @data[:fbl], opi_human, trnp_human, vnam, alg_art[1]
      )
      lines << ('                                                                ' + alg_art[2])

      lines << ('      ' + LEGEND3 + '               ' + alg_art[3])
      lines << sprintf(
        '                   %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d               %s',
        *@data.values_at(*%i[pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4]), alg_art[4]
      )
      lines << ('                                                                ' + alg_art[5])

      lines << ('      ' + LEGEND2 + '               ' + alg_art[6])
      lines << sprintf(
        '      %8s     %2d     %2d   %2s   %2d   %2d   %3s',
        lfw_human, *@data.values_at(*%i[lfs lfd lpmd lamd lpms]), lfks_human
      )

      lines.join("\n")
    end

    def opi_human
      @data[:opi].zero? ? 'off' : 'on'
    end

    def trnp_human
      notes = %w[C C# D D# E F F# G G# A A# B]
      all_notes = 5.times.flat_map { |i| notes.map { |n| "#{n}#{i+1}" } }
      all_notes[@data[:trnp]]
    end

    def vnam
      @data.values_at(*%i[vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10]).map(&:chr).join
      'helloworld'
    end

    def lfw_human
      %w[triangle saw\ down saw\ up square sine s/hold][@data[:lfw]]
    end
    
    def lfks_human
      %w[off on][@data[:lfks]]
    end

    def alg_art
      Algorithms::ART[@data[:als]]
    end

    def set(key, value)
      check = validation(key)
      unless check.include?(value)
        raise "validation #{check} failed for #{key} = #{value}" 
      end
    
      @data[key] = value
    end
  end
end
