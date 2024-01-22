module API
  module V1
    class FetchIndicator
      def all
        Indicator.all.order(:name_en)
      end

      def by_subgroup(subgroup)
        subgroup.indicators.order(:name_en).to_a
      end

      def default_by_subgroup(subgroup)
        subgroup.default_indicator
      end

      def records(indicator, params = {})
        if params.any?
          filter = FilterIndicatorRecords.new(indicator, params.slice(:category_1, :scenario, :region, :unit, :year, :start_year, :end_year, :visualization))
          filter.call.includes(:widgets, :unit, :region, :scenario).order(year: :desc)
        else
          indicator.records
        end
      end

      def by_id_or_slug(slug_or_id, filters, includes)
        rel = Indicator.where("id::TEXT = :id OR slug = :id", id: slug_or_id)
        rel = rel.includes(*includes) if includes.any?
        rel = rel.where(filters) if filters.any?
        raise ActiveRecord::RecordNotFound.new("Indicator #{slug_or_id} not found") if rel.count == 0
        rel.first!
      end
    end
  end
end
