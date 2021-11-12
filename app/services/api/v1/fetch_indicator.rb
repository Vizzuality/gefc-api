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

      # def default_slug_by_group(group)
      #   #Rails.logger.info("Fetching default_subgroup_slug_by_group here!")
      #   @cache.fetch([group, 'default_subgroup_slug']) { default_by_group(group)&.slug }
      # end

      def default_visualization(indicator)
        #Rails.logger.info("Fetching indicator default_visualization here!")
        @cache.fetch([indicator, 'default_visualization']) { default_widget(indicator).name }
      end

      def default_widget(indicator)
        #Rails.logger.info("Fetching indicator default_widget here!")
        @cache.fetch([indicator, 'default_widget']) { indicator.default_widget }
      end

      def widgets_list(indicator)
        #Rails.logger.info("Fetching indicator widgets_list here!")
        @cache.fetch([indicator, 'widgets_list']) { widgets(indicator).pluck(:name) }
      end

      def widgets(indicator)
        #Rails.logger.info("Fetching indicator widgets_list here!")
        @cache.fetch([indicator, 'widgets']) { indicator.widgets }
      end

      def category_1(indicator)
        #Rails.logger.info("Fetching indicator category_1 here!")
        @cache.fetch([indicator, 'category_1']) { records(indicator).pluck(Record.current_locale_column(:category_1)).uniq }
      end

      def category_filters(indicator)
        #Rails.logger.info("Fetching indicator category_filters here!")
        @cache.fetch([indicator, 'category_1']) do
          cached_category_filters = {}
          category_1.each do |category_1|
              cached_category_filters[category_1] = records(indicator).
                  where(Record.current_locale_column(:category_1) => category_1).
                  pluck(Record.current_locale_column(:category_2)).
                  uniq
          end
          cached_category_filters
        end
      end

      def start_date(indicator)
        #Rails.logger.info("Fetching indicator start_date here!")
        @cache.fetch([indicator, 'start_date']) { records(indicator).where("year > ?", 1900).order(year: :asc).pluck(:year).first }
      end

      def end_date(indicator)
        #Rails.logger.info("Fetching indicator end_date here!")
        @cache.fetch([indicator, 'end_date']) { records(indicator).where("year > ?", 1900).order(year: :desc).pluck(:year).first }
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

      def scenarios(indicator)
        #Rails.logger.info("Fetching indicator scenarios here!")
        @cache.fetch([indicator, 'scenarios']) do
          if records(indicator).select(:scenario_id).distinct.any?
            cached_scenarios = Scenario.where(id: records(indicator).select(:scenario_id).distinct).pluck(Scenario.current_locale_column(:name))
          else
            cached_scenarios = nil
          end
        end
      end

      def group(indicator)
        #Rails.logger.info("Fetching indicator group here!")
        @cache.fetch([indicator, 'group']) { indicator.group }
      end

      def subgroup(indicator)
        #Rails.logger.info("Fetching indicator subgroup here!")
        @cache.fetch([indicator, 'subgroup']) { indicator.subgroup }
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

      def regions(indicator)
        #Rails.logger.info("Fetching indicator regions here!")
        @cache.fetch([indicator, 'regions']) { indicator.regions }
      end
    end
  end
end
