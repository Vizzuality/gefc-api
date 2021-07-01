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
    end
  end
end
