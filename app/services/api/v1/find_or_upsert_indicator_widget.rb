module API
  module V1
    class FindOrUpsertIndicatorWidget < FindOrUpsertEntity
      def reload
        @dict = {}
        IndicatorWidget.all.each do |indicator_widget|
          @dict[indicator_widget.indicator_id] ||= {}
          @dict[indicator_widget.indicator_id][indicator_widget.widget_id] = indicator_widget
        end
      end

      private

      def lookup_attributes
        [:indicator_id, :widget_id]
      end

      def create(attributes)
        if attributes[:by_default] && attributes[:indicator_id]
          current_default = IndicatorWidget.by_default.where(indicator_id: attributes[:indicator_id]).first
        end
        IndicatorWidget.transaction do
          current_default&.update_attribute(:by_default, false)
          IndicatorWidget.create(attributes)
        end
      end

      def update(entity, attributes)
        attributes_for_update = attributes.except(*lookup_attributes)
        return entity unless attributes_for_update.any?

        if attributes_for_update[:by_default] && attributes_for_update[:indicator_id]
          current_default = IndicatorWidget.by_default.where(indicator_id: attributes_for_update[:indicator_id])
        end
        IndicatorWidget.transaction do
          current_default&.update_attribute(:by_default, false)
          entity.assign_attributes(attributes_for_update)
          entity.save if entity.changed?
        end
        entity
      end
    end
  end
end
