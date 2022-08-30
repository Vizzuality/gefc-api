module API
  module V1
    module FileGeneration
      extend ActiveSupport::Concern
      require "ox"

      included do
        helpers do
          def generate_file(records, file_format, current_locale)
            FileGenerator.new(records, file_format, current_locale).call
          end
        end
      end
    end
  end
end
