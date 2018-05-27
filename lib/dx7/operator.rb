require_relative 'validations'

module DX7
  class Operator
    include Validations

    KEYS = %i[r1 r2 r3 r4 l1 l2 l3 l4 bp ld rd lc rc rs ams ts tl pm pc pf pd].freeze
    VALIDATIONS = {
      %i[r1 r2 r3 r4 l1 l2 l3 l4 bp ld rd tl pf] => 0..99,
      %i[lc rc ams] => 0..3,
      %i[rs ts] => 0..7,
      %i[pm] => 0..1,
      %i[pc] => 0..31,
      %i[pd] => 0..14,
    }.freeze

    LEGEND = 'Pitch  Pc / Pf  Detune  EG  Rs  R1  R2  R3  R4  L1  L2  L3  L4    Level  Ld    Lc    Bp    Rc  Rd    Vel  AMS'.freeze
    KEYBOARD_SCALE_CURVES = %w[-lin -exp +exp +lin].freeze

    def initialize
      check_validations!
      @data = Hash.new(0)
    end

    def to_s
      sprintf(
        '%5s    %5.2f      %2d      %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d  %2d       %2d  %2d  %4s  %4s  %4s  %2d     %2d   %2d',
        pm_human, pitch_f, *@data.values_at(*%i[pd rs r1 r2 r3 r4 l1 l2 l3 l4 tl ld]), lc_human,
        bp_human, rc_human ,*@data.values_at(*%i[rd ts ams])
      )
    end

    def set(key, value)
      validate!(key, value)
      @data[key] = value
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
