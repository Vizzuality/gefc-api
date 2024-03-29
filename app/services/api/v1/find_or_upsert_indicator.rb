module API
  module V1
    class FindOrUpsertIndicator < FindOrUpsertEntity
      def reload
        @dict = {}
        Indicator.all.each do |indicator|
          @dict[indicator.subgroup_id] ||= {}
          @dict[indicator.subgroup_id][indicator.name_en] = indicator
        end
      end

      private

      def lookup_attributes
        [:subgroup_id, :name_en]
      end

      def create(attributes)
        # set as by_default for a subgroup
        if attributes[:by_default] && attributes[:subgroup_id]
          current_default = Indicator.by_default.where(subgroup_id: attributes[:subgroup_id]).first
        end
        Indicator.transaction do
          current_default&.update_attribute(:by_default, false)
          Indicator.create(attributes)
        end
      end

      def update(entity, attributes)
        attributes_for_update = attributes.except(*lookup_attributes)
        return entity unless attributes_for_update.any?

        if attributes_for_update[:by_default] && attributes_for_update[:subgroup_id]
          current_default = Indicator.by_default.where(subgroup_id: attributes_for_update[:subgroup_id])
        end
        Indicator.transaction do
          current_default&.update_attribute(:by_default, false)
          entity.assign_attributes(attributes_for_update)
          entity.save if entity.changed?
        end
        entity
      end
    end
  end
end
