FactoryBot.define do
  factory :data_import_attempt do
    original_file { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'files', 'gefc_test.zip')) }
  end
end
