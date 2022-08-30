module API
  module V1
    class FetchGroup
      def initialize
      end

      def all
        Group.all.order(:name_en)
      end

      def by_id_or_slug(slug_or_id)
        Group.where("id::TEXT = :id OR slug = :id", id: slug_or_id).first!
      end

      def header_image_url(group)
        group.header_image.attachment&.service_url
      end
    end
  end
end
