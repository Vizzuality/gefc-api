module API
  module V1
    class FetchGroup
      def initialize()
      end

      def all
        Rails.cache.fetch('groups') { Group.includes([:subgroups]).all.order(:name_en) }
      end
    end
  end
end
