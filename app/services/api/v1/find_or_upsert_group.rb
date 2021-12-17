module API
  module V1
    class FindOrUpsertGroup < FindOrUpsertEntity
      def reload
        @dict = Hash[Group.all.map { |e| [e.name_en, e] }]
      end

      private

      def lookup_attributes
        [:name_en]
      end

      def create(attributes)
        #TODO name should be downcased before create
        Group.create(attributes)
      end
    end
  end
end
