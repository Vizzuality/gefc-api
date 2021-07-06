module API
  module V1
    class FindOrUpsertUnit < FindOrUpsertEntity
      def reload
        @dict = Hash[Unit.all.map { |e| [e.name_en, e] }]
      end

      private

      def lookup_attributes
        [:name_en]
      end

      def create(attributes)
        Unit.create(attributes)
      end
    end
  end
end
