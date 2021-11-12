module API
  module V1
    class FetchIndicator
      def initialize()
        @cache = Rails.cache
      end

      def all
        #Rails.logger.info("Fetching indicators here!")
        @cache.fetch('indicators') { Indicator.all.order(:name_en) }
      end

      def by_subgroup(subgroup)
        #Rails.logger.info("Fetching indicators by subgroup here!")
        @cache.fetch([subgroup, 'indicators']) { subgroup.indicators.order(:name_en).to_a }
      end

      def default_by_subgroup(subgroup)
        #Rails.logger.info("Fetching indicator default_by_subgroup here!")
        @cache.fetch([subgroup, 'default_indicator']) { subgroup.default_indicator }
      end

      def records(indicator, params = {})
        if params.any?
          #Rails.logger.info("DB>>>>>>>>>>>>Fetching indicator records here!")
          filter = FilterIndicatorRecords.new(indicator, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year, :visualization))
					records = filter.call.includes(:widgets, :unit, :region, :scenario).order(year: :desc)
        else
          #Rails.logger.info("Fetching indicator records here!")
          @cache.fetch([indicator, 'records']) { indicator.records }
        end
      end

      def by_id_or_slug(slug_or_id, filters, includes)
        # Do I need to add the filters to the keys?
        #Rails.logger.info("FFFFFFFFFFFFFFetching indicator by_id_or_slug here!")
        @cache.fetch(['indicator', slug_or_id]) do
          rel = Indicator.where('id::TEXT = :id OR slug = :id', id: slug_or_id)
          rel = rel.includes(*includes) if includes.any?
          rel = rel.where(filters) if filters.any?
          rel.first!
        end
      end
    end
  end
end
