module DX7
  module Validations
    def validation(key)
      self.class::VALIDATIONS.each do |keys, v|
        return v if keys.include?(key)
      end
  
      raise "validation not found for #{key}" if val.nil?
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
