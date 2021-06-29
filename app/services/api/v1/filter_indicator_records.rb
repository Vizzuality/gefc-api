module API
  module V1
    class FilterIndicatorRecords
      def initialize(indicator_id, params = {})
        @query = Record.where(indicator_id: indicator_id)
        filter_by_category(params[:category_1])
        filter_by_year_range(params[:start_year], params[:end_year])
      end

      def call
        @query
      end

      private

      def filter_by_category(category_1)
        return unless category_1.present?

        @query = @query.where(Record.current_locale_column(:category_1) => category_1)
      end

      def filter_by_year_range(start_year, end_year)
        @query = @query.where('year >= ?', start_year) if start_year.present?
        @query = @query.where('year <= ?', end_year) if end_year.present?
      end
    end
  end
end
