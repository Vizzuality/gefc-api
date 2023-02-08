require "aws-sdk-s3"

module API
  module V1
    class EnergyBalance
      def initialize
        @object_key = "energy_balance.json"
        @bucket_name = Rails.application.credentials[:aws_bucket]
        @s3_client = Aws::S3::Client.new(
          region: Rails.application.credentials[:aws_region],
          credentials: Aws::Credentials.new(Rails.application.credentials[:aws_access_key_id], Rails.application.credentials[:aws_secret_access_key])
        )
      end

      def get_file
        @s3_client.get_object(bucket: @bucket_name, key: @object_key).body
      end

      def upload_file(file_path)
        puts "Uploading #{file_path}..."

        File.open(file_path, "rb") do |file|
          response = @s3_client.put_object(bucket: @bucket_name, key: @object_key, body: file)
          return !!response.etag
        end
      end
    end
  end
end
