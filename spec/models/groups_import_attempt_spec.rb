require "rails_helper"

RSpec.describe GroupsImportAttempt, type: :model do
  it "starts an import when created" do
    file_path = Rails.root.join("spec", "files", "local_csv", "groups_import_test.csv")
    importer = instance_double(GroupsImporter)
    allow(GroupsImporter).to receive(:new).and_return(importer)
    expect(importer).to receive(:import_from_file)
    create(:groups_import_attempt, original_file: fixture_file_upload(file_path))
  end
end
