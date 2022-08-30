module API
  module V1
    class FindOrUpsertRegion < FindOrUpsertEntity
      def reload
        @dict = Hash[Region.all.map { |g| [g.name_en, g] }]
      end

      private

      def lookup_attributes
        [:name_en]
      end

      def create(attributes)
        Region.create(attributes)
      end

      def update(entity, attributes)
        attributes_for_update = attributes.except(*lookup_attributes)
        return entity unless attributes_for_update.any?
        begin
          entity.update(attributes_for_update)
        rescue RGeo::Error::InvalidGeometry
          # no-op
        end
        entity
      end
    end
  end
end
