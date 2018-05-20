module DX7
  class Voice
    def initialize
      @operators = 6.times.map { Operator.new }
    end

    def to_s
      lines = ['      ' + Operator::LEGEND]
      @operators.each_with_index { |op, i| lines << "OP#{i+1}   #{op}" }
      lines.join("\n")
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
