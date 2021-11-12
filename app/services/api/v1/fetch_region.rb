module API
  module V1
    class FetchRegion
      def initialize()
        @cache = Rails.cache
      end

      def all
        #Rails.logger.info("Fetching regions here!")
        @cache.fetch('regions') { Region.all }
      end

      def by_id(id)
        #Rails.logger.info("FFFFFFFFFFFFFFetching group by_id_or_slug here!")
        @cache.fetch(['region', id]) { Region.find(id) }
      end
    end
  end
end
