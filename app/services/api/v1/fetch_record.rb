module API
  module V1
    class FetchRecord
      def initialize()
      end

      def widgets_list(record)
        #Rails.logger.info("Fetching record widgets_list here!")
        Rails.cache.fetch([record, 'widgets_list']) { widgets(record).pluck(:name).uniq }
      end

      def widgets(record)
        #Rails.logger.info("Fetching record widgets here!")
        Rails.cache.fetch([record, 'widgets']) { record.widgets }
      end

      def scenario(record)
        #Rails.logger.info("Fetching record widgets here!")
        Rails.cache.fetch([record, 'scenario']) { record.scenario }
      end

      def region(record)
        #Rails.logger.info("Fetching record region here!")
        Rails.cache.fetch([record, 'region']) { record.region }
      end

      def unit(record)
        #Rails.logger.info("Fetching record unit here!")
        Rails.cache.fetch([record, 'unit']) { record.unit }
      end
    end
  end
end
