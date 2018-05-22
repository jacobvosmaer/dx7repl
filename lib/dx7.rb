module DX7
  class Voice
    KEYS = %i[
      pr1 pr2 pr3 pr4 pl1 pl2 pl3 pl4
      als fbl opi lfs lfd lpmd pamd lfks lfw lpms trnp
      vnam1 vnam2 vnam3 vnam4 vnam5 vnam6 vnam7 vnam8 vnam9 vnam10
    ].freeze

    LEGEND1 = 'Alg  Fbl  Osc.sync  Transpose    Voice name'.freeze
    LEGEND3 = 'Pitch EG     R1  R2  R3  R4  L1  L2  L3  L4'.freeze
    LEGEND2 = 'LFO Wave  Speed  Delay  Pmd  Amd  Pms  Sync'.freeze

ALG_ART = [
  [
    '      6 >',
    '      |',
    '      5',
    '      |',
    '  2   4',
    '  |   |',
    '  1 - 3'
  ],
  [
    '      6',
    '      |',
    '      5',
    '      |',
    '< 2   4',
    '  |   |',
    '  1 - 3'
  ],
  [
    '      ',
    '      ',
    '  3   6 >',
    '  |   |',
    '  2   5',
    '  |   |',
    '  1 - 4'
  ],
  [
    '      ',
    '      ',
    '  3   6 >',
    '  |   | .',
    '  2   5 .',
    '  |   | .',
    '  1 - 4 >'
  ],
  [
    '      ',
    '      ',
    '     ',
    '     ',
    '  2   4   6 >',
    '  |   |   |',
    '  1 - 3 - 5'
  ],
  [
    '      ',
    '      ',
    '     ',
    '     ',
    '  2   4   6 >',
    '  |   |   | .',
    '  1 - 3 - 5 >'
  ],
  [
    '      ',
    '      ',
    '           6 >',
    '           |  ',
    '  2    4   5  ',
    '  |    |  / ',
    '  1 -- 3 '
  ],
  [
    '      ',
    '      ',
    '           6 ',
    '           |  ',
    '  2  < 4   5  ',
    '  |    |  / ',
    '  1 -- 3 '
  ],
  [
    '      ',
    '      ',
    '           6 ',
    '           |  ',
    '< 2    4   5  ',
    '  |    |  / ',
    '  1 -- 3 '
  ],
  [
    '      ',
    '      ',
    '          3 > ',
    '          |  ',
    '  5  6    2     ',
    '   \ |    |   ',
    '     4 -- 1 '
  ],
  [
    '      ',
    '      ',
    '          3 ',
    '          |  ',
    '  5  6 >  2     ',
    '   \ |    |   ',
    '     4 -- 1 '
  ],
  [
    '      ',
    '      ',
    '           ',
    '             ',
    '  4  5  6    2 >    ',
    '   \ | /     |   ',
    '     3 ----- 1 '
  ],
  [
    '      ',
    '      ',
    '           ',
    '             ',
    '  4  5  6 >  2    ',
    '   \ | /     |   ',
    '     3 ----_ 1 '
  ],
  [
    '      ',
    '      ',
    '      5  6 >',
    '      | /',
    '  2   4 ',
    '  |   | ',
    '  1 - 3 '
  ],
  [
    '      ',
    '      ',
    '      5  6 ',
    '      | /',
    '< 2   4 ',
    '  |   | ',
    '  1 - 3 '
  ],
].freeze

    def initialize
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
      ALG_ART[@data[:als]]
    end
  end

  class Operator
    KEYS = %i[r1 r2 r3 r4 l1 l2 l3 l4 bp ld rd lc rc rs ams ts tl pm pc pf pd].freeze
    LEGEND = 'Pitch  Pc / Pf  Detune  EG  Rs  R1  R2  R3  R4  L1  L2  L3  L4    Level  Ld    Lc    Bp    Rc  Rd    Vel  AMS'.freeze
    KEYBOARD_SCALE_CURVES = %w[-lin -exp +exp +lin].freeze

    def initialize
      @data = Hash.new(0)
    end

    def to_s
      sprintf(
        '%5s    %5.2f      %2d      %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d       %2d  %2d  %4s  %4s  %4s  %2d     %2d   %2d',
        pm_human, pitch_f, *@data.values_at(*%i[pd rs r1 r2 r3 r4 l1 l2 l3 l4 tl ld]), lc_human,
        bp_human, rc_human ,*@data.values_at(*%i[rd ts ams])
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

    def lc_human
      KEYBOARD_SCALE_CURVES[@data[:lc]]
    end

    def rc_human
      KEYBOARD_SCALE_CURVES[@data[:rc]]
    end

    def bp_human
      notes = %w[A A# B C D D# E F F# G G#]
      all_notes = 9.times.flat_map { |i| notes.map { |n| "#{n}#{i-1}" } }
      all_notes[@data[:bp]]
    end
  end
end
