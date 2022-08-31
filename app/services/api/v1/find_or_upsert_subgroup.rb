module API
  module V1
    class FindOrUpsertSubgroup < FindOrUpsertEntity
      def call(attributes, group)
        super(attributes.merge({group_id: group.id}))
      end

      def reload
        @dict = {}
        Subgroup.all.each do |subgroup|
          @dict[subgroup.group_id] ||= {}
          @dict[subgroup.group_id][subgroup.name_en] = subgroup
        end
      end

      private

      def lookup_attributes
        [:group_id, :name_en]
      end

      def create(attributes)
        if attributes[:by_default] && attributes[:group_id]
          current_default = Subgroup.by_default.where(group_id: attributes[:group_id]).first
        end
        Subgroup.transaction do
          current_default&.update_attribute(:by_default, false)
          Subgroup.create(attributes)
        end
      end

      def update(entity, attributes)
        attributes_for_update = attributes.except(*lookup_attributes)
        return entity unless attributes_for_update.any?

        if attributes_for_update[:by_default] && attributes_for_update[:group_id]
          current_default = Subgroup.by_default.where(group_id: attributes_for_update[:group_id])
        end
        Subgroup.transaction do
          current_default&.update_attribute(:by_default, false)
          entity.assign_attributes(attributes_for_update)
          entity.save if entity.changed?
        end
        entity
      end
    end
  end
end
