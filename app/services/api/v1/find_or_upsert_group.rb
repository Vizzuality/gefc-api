module API
  module V1
    class FindOrUpsertGroup < FindOrUpsertEntity
      def reload
        @dict = Hash[Group.all.map { |e| [e.name_en, e] }]
      end

      private

      def lookup_attributes
        [:name_en, :name_cn]
      end

      def create(attributes)
        Group.create(attributes)
      end
    end
  end
end
