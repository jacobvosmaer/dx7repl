module DX7
  class Voice
    KEYS = %i[
      pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4
      als fbl opi lfs lfd lpmd pamd lfks lfw lpms trnp
      vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10
    ].freeze

    LEGEND1 = 'Alg  Fbl  Osc.sync  Transpose  Voice name     Pitch EG  R1  R2  R3  R4  L1  L2  L3  L4'.freeze

    def initialize
      @operators = 6.times.map { Operator.new }
      @data = Hash.new(0)
    end

    def to_s
      lines = []
      lines << ('      ' + LEGEND1)
      lines << sprintf(
        '       %2d   %2d       %3s        %2s  %s               %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d',
        @data[:als], @data[:fbl], opi_human, trnp_human, vnam, *@data.values_at(*%i[pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4])
      )
      lines << ''
      lines << ('      ' + Operator::LEGEND)
      @operators.each_with_index { |op, i| lines << "OP#{i+1}   #{op}" }
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
  end

  class Operator
    KEYS = %i[r1 r2 r3 r4 l1 l2 l3 l4 bp ld rd lc rc rs ams ts tl pm pc pf pd].freeze
    LEGEND = 'Pitch  Pc / Pf  Detune  EG  Rs  R1  R2  R3  R4  L1  L2  L3  L4    Level  Ld  Lc  Bp  Rc  Rd    Vel  AMS'.freeze

    def initialize
      @data = Hash.new(0)
    end

    def to_s
      sprintf(
        '%5s    %5.2f      %2d      %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d       %2d  %2d  %2d  %2d  %2d  %2d     %2d   %2d',
        pm_human, pitch_f, *@data.values_at(*%i[pd rs r1 r2 r3 r4 l1 l2 l3 l4 tl ld lc bp rc rd ts ams])
      )
    end

    def pm_human
      @data[:pm].zero? ? 'ratio' : 'fixed'
    end
    
    def pitch_f
      coarse = @data[:pc].to_f
      coarse = 0.5 if @data[:pc].zero?
      delta = 2*coarse / 100
      coarse + @data[:pf] * delta
    end
  end
end
