module API
  module V1
    class FindOrCreateWidget < FindOrCreateEntity
      def call(attributes)
        super(attributes, 'name')
      end

      def reload
        @dict = Hash[Widget.all.map { |e| [e.name, e] }]
      end

      private

      def create(attributes)
        Widget.create(name: attributes['name'])
      end
    end
  end
end
