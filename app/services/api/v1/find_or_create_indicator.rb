module API
  module V1
    class FindOrCreateIndicator < FindOrCreateEntity
      def call(attributes, subgroup)
        super(
          attributes.merge({'subgroup' => subgroup, 'subgroup_id' => subgroup.id}), 'subgroup_id', 'indicator_en'
        )
      end

      def reload
        @dict = {}
        Indicator.all.each do |indicator|
          @dict[indicator.subgroup_id] ||= {}
          @dict[indicator.subgroup_id][indicator.name_en] = indicator
        end
      end

      private

      def create(attributes)
        Indicator.create(
          subgroup: attributes['subgroup'],
          name_en: attributes['indicator_en'],
          name_cn: attributes['indicator_cn']
        )
      end
    end
  end
end
