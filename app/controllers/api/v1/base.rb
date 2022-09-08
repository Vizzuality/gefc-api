require "grape-swagger"

module API
  module V1
    class Base < API::Base
      mount API::V1::Groups
      mount API::V1::Indicators
      mount API::V1::Regions
      mount API::V1::Users
      mount API::V1::Downloads
      mount API::V1::Health

      # add_swagger_documentation
      add_swagger_documentation(
        api_version: "v1",
        hide_documentation_path: true,
        mount_path: "#{Rails.configuration.relative_url_root}/api/v1/swagger_doc",
        hide_format: true
      )
    end
  end
end
