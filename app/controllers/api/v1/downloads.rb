module API
  module V1
    class Downloads < Grape::API
      include API::V1::Defaults
      include API::V1::Authentication
      include API::V1::Authorization
      include API::V1::FileGeneration

      desc "Returns a csv, json or xml file with the records of the indicator", {
        headers: {
          "Authentication" => {
            description: "JWT that Validates the user as allowed to download",
            required: true
          }
        }
      }
      params do
        requires :id, type: String, desc: "ID / slug of the indicator"
        requires :file_format, type: String, desc: "file format, must be csv, json or xml"
        optional :category_1, type: String, desc: "Name of the category"
        optional :start_year, type: Integer, desc: "Start year"
        optional :end_year, type: Integer, desc: "End year"
      end
      get 'downloads' do
        if authenticate! and authorize!
          indicator = Indicator.find_by_id_or_slug!(permitted_params[:id], {}, [])
          filter = FilterIndicatorRecords.new(indicator, params.slice(:category_1, :start_year, :end_year))
          records = filter.call.includes(:unit, :region)

          file_name = generate_file(records, permitted_params[:file_format], I18n.locale)

          content_type "application/octet-stream"
          header['Content-Disposition'] = "attachment; filename=#{file_name.split('/').last}"
          env['api.format'] = :binary
          File.open(file_name, 'rb').read
        else
          error!({ :error_code => 401, :error_message => authorize! }, 401)
        end
      end
    end
  end
end
