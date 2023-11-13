require_relative 'validations'

module DX7
  class Operator
    include Validations

    # keys are in VMEM packed format order
    KEYS = %i[r1 r2 r3 r4 l1 l2 l3 l4 bp ld rd lc rc rs ams ts tl pm pc pf pd].freeze

    VALIDATIONS = {
      %i[r1 r2 r3 r4 l1 l2 l3 l4 bp ld rd tl pf] => 0..99,
      %i[lc rc ams] => 0..3,
      %i[rs ts] => 0..7,
      %i[pm] => 0..1,
      %i[pc] => 0..31,
      %i[pd] => 0..14,
    }.freeze

    LEGEND = '   pm    pc/pf    pd  . rs  r1  r2  r3  r4  l1  l2  l3  l4  . tl  ld    lc    bp    rc  rd  . ts  ams'.freeze
    KEYBOARD_SCALE_CURVES = %w[-lin -exp +exp +lin].freeze

    def self.default(index)
      op = new

      {
        r1: 99, r2: 99, r3: 99, r4: 99, l1: 99, l2: 99, l3: 99, l4: 0,
        bp: 39, ld: 0, rd: 0, lc: 0, rc: 0, rs: 0, ams: 0, ts: 0, tl: 0,
        pm: 0, pc: 1, pf: 0, pd: 7,
      }.each do |k, v|
        op = op.set(k, v)
      end
    
      op = op.set(:tl, 99) if index == 0
    
      op
    end

    def initialize(data: nil, cur: nil)
      check_validations!
      @data = data || Hash.new(0).freeze
      @cur = cur
    end

    def to_s
      env_values = %i[rs r1 r2 r3 r4 l1 l2 l3 l4 tl ld].flat_map { |k| data_cur(k) }

      format = '%5s%s  %s'
      if ratio?
        format << '%5.2f'
      else
        format << '%5.4g'
      end
      format << '%s   %2d%s . %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s %2d%s . %2d%s %2d%s %4s%s %4s%s %4s%s %2d%s . %2d%s  %2d%s'

      sprintf(format ,
        pm_human, cur(:pm), cur(:pc), pitch_f, cur(:pf), pd_human, cur(:pd),
        *env_values,
        lc_human, cur(:lc), bp_human, cur(:bp), rc_human, cur(:rc),
        *data_cur(:rd), *data_cur(:ts), *data_cur(:ams)
      )
    end

    def data_cur(key)
      [@data.fetch(key), cur(key)]
    end

    def set(key, value)
      validate!(key, value)

      self.class.new(data: @data.merge(key => value).freeze, cur: key)
    end

    def cur(key)
      @cur == key ? '*' : ' '
    end

    def clear_cur
      self.class.new(data: @data)
    end

    def pm_human
       ratio? ? 'ratio' : 'fixed'
    end

    def ratio?
      @data[:pm].zero?
    end

    def pitch_f
      if ratio?
        coarse = @data[:pc].zero? ? 0.5 : @data[:pc].to_f
        delta = 2*coarse / 100
        coarse + @data[:pf] * delta
      else
        coarse = 10.0 ** (@data[:pc] & 3)
        f = 10 ** (1/100.0)
        coarse * (f ** @data[:pf])
      end
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

    def pd_human
      @data[:pd] - 7
    end
  end
end
