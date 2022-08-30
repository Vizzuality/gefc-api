module API
  module V1
    class FetchRegion
      def initialize() end

      def all
        Region.all
      end

      def by_id(id)
        Region.find(id)
      end
    end
  end
end
