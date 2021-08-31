module API
  module V1
    class FindOrUpsertScenario < FindOrUpsertEntity
      def reload
        @dict = Hash[Scenario.all.map { |g| [g.name_en, g] }]
      end

      private

      def lookup_attributes
        [:name_en]
      end

      def create(attributes)
        Scenario.create(attributes)
      end

      def update(entity, attributes)
        attributes_for_update = attributes.except(*lookup_attributes)
        return entity unless attributes_for_update.any?
        entity.update(attributes_for_update)
        
        entity
      end
    end
  end
end
