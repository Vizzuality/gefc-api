module API
  module V1
    class FetchGroup
      def initialize()
      end

      def all
        #Rails.logger.info("Fetching groups here!")
        Rails.cache.fetch('groups') { Group.all.order(:name_en) }
      end

      def by_id_or_slug(slug_or_id)
        #Rails.logger.info("FFFFFFFFFFFFFFetching group by_id_or_slug here!")
        Rails.cache.fetch(['group', slug_or_id]) { Group.where('id::TEXT = :id OR slug = :id', id: slug_or_id).first! }
      end

      def header_image_url(group)
        #Rails.logger.info("FFFFFFFFFFFFFFetching group header_image_url here!")
        Rails.cache.fetch([group, 'header_image_url']) { group.header_image.attachment&.service_url }
      end
    end
  end
end
