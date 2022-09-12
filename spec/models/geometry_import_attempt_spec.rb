require "rails_helper"

RSpec.describe GeometryImportAttempt, type: :model do
  it "starts an import when created" do
    file_path = Rails.root.join("spec", "files", "local_json", "geometry_points_import_test.geojson")
    importer = instance_double(GeometryImporter)
    allow(GeometryImporter).to receive(:new).and_return(importer)
    expect(importer).to receive(:import_from_json)
    create(:geometry_import_attempt, original_file: fixture_file_upload(file_path))
  end
end
