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
      %i[vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10] => 32..126,
    }

    LEGEND1 = 'Alg  Fbl  Osc.sync  Transpose    Voice name'.freeze
    LEGEND3 = 'Pitch EG     R1  R2  R3  R4  L1  L2  L3  L4'.freeze
    LEGEND2 = 'LFO Wave  Speed  Delay  Pmd  Amd  Pms  Sync'.freeze

    def self.default
      voice = new

      {
        pr1: 99, pr2: 99, pr3: 99, pr4: 99, pl1: 50, pl2: 50, pl3: 50, pl4: 50,
        opi: 1, lfs: 35, lfks: 1, lpms: 3, trnp: 24,
        vnam1: 73, vnam2: 78, vnam3: 73, vnam4: 84, vnam5: 32, vnam6: 86, vnam7: 79, vnam8: 73, vnam9: 67, vnam10: 69,
      }.each do |key, value|
        voice = voice.set(key, value)
      end
      
      voice
    end

    def initialize(data: nil, operators: nil, cur: nil)
      check_validations!
      @operators = operators || 6.times.map { |i| Operator.default(i) }.freeze
      @data = data || Hash.new(0)
      @cur = cur
    end

    def to_s
      lines = []

      lines << ('      ' + Operator::LEGEND)
      @operators.each_with_index { |op, i| lines << "OP#{i+1}   #{op}" }
      lines << ''

      lines << ('      ' + LEGEND1 + '               ' + alg_art[0])
      lines << sprintf(
        '       %2d%s  %2d%s      %3s%s        %2s%s   %10s               %s',
        @data[:als]+1, cur(:als), *data_cur(:fbl), opi_human, cur(:opi), trnp_human, cur(:trnp), vnam, alg_art[1]
      )
      lines << ('                                                                ' + alg_art[2])

      lines << ('      ' + LEGEND3 + '               ' + alg_art[3])
      lines << sprintf(
        '                   %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s              %s',
        *%i[pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4].flat_map { |k| data_cur(k) }, alg_art[4]
      )
      lines << ('                                                                ' + alg_art[5])

      lines << ('      ' + LEGEND2 + '               ' + alg_art[6])
      lines << sprintf(
        '      %8s%s    %2d%s    %2d%s  %2s%s  %2d%s  %2d%s  %3s%s',
        lfw_human, cur(:lfw), *%i[lfs lfd lpmd lamd lpms].flat_map { |k| data_cur(k) }, lfks_human, cur(:lfks)
      )

      lines.join("\n")
    end

    def cur(key)
      @cur == key ? '*' : ' '
    end
    
    def data_cur(key)
      [@data[key], cur(key)]
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
      s = ''
      %i[vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10].each do |key|
        b = @data[key]
        if b.zero?
          s << ' '
        else
          s << b.chr
        end
      end
      
      s
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

    def set(key, value, output: nil)
      validate!(key, value)  
  
      self.class.new(
        data: @data.merge(key => value).freeze,
        operators: @operators.map(&:clear_cur),
        cur: key
      )
    end

    def set_op(op, key, value, output: nil)
      index = %i[op1 op2 op3 op4 op5 op6].index(op)
      raise "invalid op: #{op.inspect}" if index.nil?
    
      operators = @operators.map(&:clear_cur)
      operators[index] = @operators[index].set(key, value)
    
      self.class.new(data: @data, operators: operators)
    end
  end
end
