module DX7
  module Validations
    def validate!(key, value)
      raise "unknown key: #{key}" unless self.class::KEYS.include?(key)

      check = validation(key)
      unless check.include?(value)
        raise "validation #{check} failed for #{key} = #{value}" 
      end
    end

    def validation(key)
      self.class::VALIDATIONS.each do |keys, v|
        return v if keys.include?(key)
      end
  
      raise "validation not found for #{key}"
    end

    def check_validations!
      keys = self.class::KEYS
      validated_keys = self.class::VALIDATIONS.keys.flatten
    
      keys.each do |k|
        raise "key #{k} has no validation" unless validated_keys.include?(k)
      end
    
      validated_keys.each do |k|
        raise "unknown key #{k} in validations" unless keys.include?(k)
      end
    end
  end
end
