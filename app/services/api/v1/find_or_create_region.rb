module API
  module V1
    class FindOrCreateRegion < FindOrCreateEntity
      def call(attributes)
        super(attributes, 'region_en')
      end

      def reload
        @dict = Hash[Region.all.map { |g| [g.name_en, g] }]
      end

      private

      def create(attributes)
        region_type = attributes['region_type']&.downcase&.split(' ')&.join('_')&.to_sym
        Region.create(
          name_en: attributes['region_en'],
          name_cn: attributes['region_cn'],
          region_type: region_type
        )
      end
    end
  end
end
