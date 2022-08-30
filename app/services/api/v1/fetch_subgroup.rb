module API
  module V1
    class FetchSubgroup
      def initialize() end

      def all
        Subgroup.all.order(:name_en)
      end

      def by_group(group)
        group.subgroups.order(:name_en).to_a
      end

      def default_by_group(group)
        group.default_subgroup
      end

      def default_slug_by_group(group)
        default_by_group(group)&.slug
      end

      def by_id_or_slug(slug_or_id, filters)
        Subgroup.
          where('id::TEXT = :id OR slug = :id', id: slug_or_id).
          # where(filters).
          first!
      end
    end
  end
end
