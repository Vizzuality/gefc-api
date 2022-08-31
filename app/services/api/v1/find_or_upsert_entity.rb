# @abstract
module API
  module V1
    class FindOrUpsertEntity
      include Singleton

      def initialize
        reload
      end

      class << self
        delegate :call, to: :instance
        delegate :reload, to: :instance
      end

      def call(entity_attributes)
        lookup_keys = lookup_attributes.map { |a| entity_attributes[a] }
        entity = lookup(*lookup_keys)
        entity = if entity
          update(entity, entity_attributes)
        else
          create(entity_attributes)
        end
        add(entity, *lookup_keys)
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

      def update(entity, attributes)
        attributes_for_update = attributes.except(*lookup_attributes)
        return entity unless attributes_for_update.any?

        entity.assign_attributes(attributes_for_update)
        entity.save if entity.changed?

        entity
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
