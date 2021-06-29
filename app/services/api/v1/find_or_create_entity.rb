# @abstract
module API
  module V1
    class FindOrCreateEntity
      include Singleton

      def initialize
        reload
      end

      class << self
        delegate :call, to: :instance
        delegate :reload, to: :instance
      end

      # @param lookup_keys [Array<String>]
      # @param entity_attributes [Hash]
      def call(entity_attributes, *lookup_attributes)
        lookup_keys = lookup_attributes.map { |a| entity_attributes[a] }
        entity = lookup(*lookup_keys)
        unless entity
          entity = create(entity_attributes)
          add(entity, *lookup_keys)
        end
        entity
      end

      # @abstract
      # @raise [NotImplementedError] when not defined in subclass
      def reload
        raise NotImplementedError
      end

      private

      # @abstract
      # @raise [NotImplementedError] when not defined in subclass
      def create(attributes)
        raise NotImplementedError
      end

      def lookup(*lookup_keys)
        @dict.dig(*lookup_keys)
      end

      def add(entity, *lookup_keys)
        last_key = lookup_keys.pop
        h = @dict
        # it's a nested hash, first make sure we have all the levels
        lookup_keys.each do |key|
          h[key] ||= {}
          h = h[key]
        end
        # insert the value
        h[last_key] = entity
      end
    end
  end
end
