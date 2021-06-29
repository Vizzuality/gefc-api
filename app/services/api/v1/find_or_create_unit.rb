module API
  module V1
    class FindOrCreateUnit < FindOrCreateEntity
      def call(attributes)
        super(attributes, 'units_en')
      end

      def reload
        @dict = Hash[Unit.all.map { |e| [e.name_en, e] }]
      end

      private

      def create(attributes)
        Unit.create(
          name_en: attributes['units_en'],
          name_cn: attributes['units_cn']
        )
      end
    end
  end
end
