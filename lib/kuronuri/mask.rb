require 'digest/sha1'

module Kuronuri
  module Mask
    def mask(attribute)
      method_name = "#{::Digest::SHA1.hexdigest(attribute.to_s)}".to_sym

      instance_eval do
        define_method(method_name, instance_method(attribute.to_sym))
        private method_name

        define_method(attribute.to_sym) do
          return __send__ method_name if @kuronuri_allow_access
          ''
        end

        define_method("peep_into_#{attribute.to_s}".to_sym) do
          __send__ method_name
        end
      end
    end

    def self.extended(klass)
      klass.instance_eval do
        @kuronuri_allow_access = false

        define_method(:peep) do |&block|
          @kuronuri_allow_access = true
          block.call(self)
          @kuronuri_allow_access = false
        end
      end
    end
  end
end