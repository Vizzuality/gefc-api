module API
  module V1
    class FetchSubgroup
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

      def by_group_id_and_id_or_slug(group_id, slug_or_id)
        Subgroup
          .where(group_id: group_id)
          .where("id::TEXT = :id OR slug = :id", id: slug_or_id)
          .first!
      end
    end
  end
end
