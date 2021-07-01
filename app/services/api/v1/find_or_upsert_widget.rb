module API
  module V1
    class FindOrUpsertWidget < FindOrUpsertEntity
      def reload
        @dict = Hash[Widget.all.map { |e| [e.name, e] }]
      end

      private

      def lookup_attributes
        [:name]
      end

      def create(attributes)
        Widget.create(attributes)
      end
    end
  end
end
