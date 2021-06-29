module API
  module V1
    class FindOrCreateSubgroup < FindOrCreateEntity
      def call(attributes, group)
        super(attributes.merge({'group' => group, 'group_id' => group.id}), 'group_id', 'subgroup_en')
      end

      def reload
        @dict = {}
        Subgroup.all.each do |subgroup|
          @dict[subgroup.group_id] ||= {}
          @dict[subgroup.group_id][subgroup.name_en] = subgroup
        end
      end

      private

      def create(attributes)
        Subgroup.create(
          group: attributes['group'],
          name_en: attributes['subgroup_en'],
          name_cn: attributes['subgroup_cn']
        )
      end
    end
  end
end
