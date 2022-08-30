module API
  module V1
    class FilterIndicatorRecords
      def initialize(indicator, params = {})
        init_query(indicator, params)
        filter_by_scenario(params['scenario'])
        filter_by_region(params['region'])
        filter_by_unit(params['unit'])
        filter_by_category(params['category_1'])
        filter_by_year_or_range(params['year'], params['start_year'], params['end_year'])
      end

      def call
        @query
      end

      private

      def init_query(indicator, params)
        unless params['visualization'].nil?
          @query = Widget.where(name: params['visualization']).first.records.where(indicator_id: indicator.id)
        else
          @query = Record.where(indicator_id: indicator.id)
        end
      end

      def filter_by_scenario(scenario)
        return unless scenario.present?

        @query = @query.where(scenario_id: scenario)
      end

      def filter_by_region(region)
        return unless region.present?

        @query = @query.where(region_id: region)
      end

      def filter_by_unit(unit)
        return unless unit.present?

        @query = @query.where(unit_id: unit)
      end

      def filter_by_category(category_1)
        return unless category_1.present?

        @query = @query.where(Record.current_locale_column(:category_1) => category_1)
      end

      def filter_by_year_or_range(year, start_year, end_year)
        if year.present?
          @query = @query.where(year: year)
        else
          @query = @query.where('year >= ?', start_year) if start_year.present?
          @query = @query.where('year <= ?', end_year) if end_year.present?
        end
      end
    end
  end
end
