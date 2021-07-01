require 'rails_helper'

RSpec.describe GeometryPointsImportAttempt, type: :model do
  it 'starts an import when created' do
    file_path = Rails.root.join('spec', 'files', 'local_json', 'geometry_points_import_test.geojson')
    importer = instance_double(GeometryPointsImporter)
    allow(GeometryPointsImporter).to receive(:new).and_return(importer)
    expect(importer).to receive(:import_from_json)
    attempt = create(:geometry_points_import_attempt, original_file: fixture_file_upload(file_path))
  end
end
