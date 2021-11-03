module API
  module V1
    class FetchSubgroup
      def initialize()
        @cache = Rails.cache
      end

      def all
        #Rails.logger.info("Fetching subgroups here!")
        @cache.fetch('subgroups') { Subgroup.all.order(:name_en) }
      end

      def by_group(group)
        #Rails.logger.info("Fetching subgroups by_group here!")
        @cache.fetch([group, 'subgroups']) { group.subgroups.order(:name_en).to_a }
      end

      def default_by_group(group)
        #Rails.logger.info("Fetching default_subgroup_by_group here!")
        @cache.fetch([group, 'default_subgroup']) { group.default_subgroup }
      end

      def default_slug_by_group(group)
        #Rails.logger.info("Fetching default_subgroup_slug_by_group here!")
        @cache.fetch([group, 'default_subgroup_slug']) { default_by_group(group)&.slug }
      end

      def by_id_or_slug(slug_or_id, filters)
        # Do I need to add the filters to the keys?
        #Rails.logger.info("FFFFFFFFFFFFFFetching subgroup by_id_or_slug here!")
        @cache.fetch(['subgroup', slug_or_id]) do
          Subgroup.
            where('id::TEXT = :id OR slug = :id', id: slug_or_id).
            where(filters).
            first!
        end
      end
    end
  end
end
