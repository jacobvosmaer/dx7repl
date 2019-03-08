require_relative 'voice'
require_relative 'operator'

module DX7
  class PackedVoice
    def self.parse(bindata)
      if bindata.bytesize != 128
        raise "expect 128 bytes of DX7 packed voice data"
      end

      operators = 6.times.map do |i|
        binvoice = bindata.bytes[(5 - i) * 17, 17]
        op_hash = {}
        j = 0
      
        Operator::KEYS.each do |key|
          next if %i[rc pd ts pc].include?(key)

          op_hash[key] = binvoice[j]
          j += 1
        end
      
        op_hash[:lc] = binvoice[11] & 0b11
        op_hash[:rc] = (binvoice[11] >> 2) & 0b11
      
        op_hash[:rs] = binvoice[12] & 0b111
        op_hash[:pd] = binvoice[12] >> 3
      
        op_hash[:ams] = binvoice[13] & 0b11
        op_hash[:ts] = (binvoice[13] >> 2) & 0b1111
      
        op_hash[:pm] = binvoice[15] & 0b1
        op_hash[:pc] = (binvoice[15] >> 1) & 0b11111

        Operator.new(data: op_hash)
      end

      voice_hash = {}
      binvoice = bindata.bytes
      j = 102
      Voice::KEYS.each do |key|
        next if %i[opi lfw lpms].include?(key)
      
        voice_hash[key] = binvoice[j]
        j += 1
      end
      
      voice_hash[:als] = binvoice[110] & 0b11111
      
      voice_hash[:fbl] = binvoice[111] & 0b111
      voice_hash[:opi] = (binvoice[111] >> 3) & 0b1
      
      voice_hash[:lfks] = binvoice[116] & 0b1
      voice_hash[:lfw] = (binvoice[116] >> 1) & 0b111
      voice_hash[:lpms] = (binvoice[116] >> 4) & 0b111

      return Voice.new(data: voice_hash, operators: operators)
    end
  end
end
