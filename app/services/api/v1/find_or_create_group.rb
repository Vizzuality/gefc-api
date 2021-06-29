module API
  module V1
    class FindOrCreateGroup < FindOrCreateEntity
      def call(attributes)
        super(attributes, 'group_en')
      end

      def reload
        @dict = Hash[Group.all.map { |e| [e.name_en, e] }]
      end

      private

      def create(attributes)
        Group.create(
          name_en: attributes['group_en'],
          name_cn: attributes['group_cn']
        )
      end
    end
  end
end
