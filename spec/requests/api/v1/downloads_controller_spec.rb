require "rails_helper"

RSpec.describe API::V1::Downloads do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let(:indicator) { create(:indicator) }
  let!(:record1) { create(:record, indicator: indicator, year: 2020) }
  let!(:record2) { create(:record, indicator: indicator, year: 2021) }

  describe "GET downloads" do
    let!(:admin) { create(:user, :admin) }
    before do
      ENV["DOWNLOADS_PATH"] = "/tmp/gefc_test/"
      FileUtils.mkdir_p(ENV["DOWNLOADS_PATH"]) unless File.directory?(ENV["DOWNLOADS_PATH"])
    end
    after do
      dir_path = ENV["DOWNLOADS_PATH"]
      Dir.foreach(dir_path) do |f|
        fn = File.join(dir_path, f)
        File.delete(fn) if f != "." && f != ".." && f != ".keep"
      end
    end

    context "When logged in as a user with valid role" do
      it "returns 200 and status ok" do
        header "Authentication", login_and_get_jwt(admin)
        params = {'id': indicator.id, "file_format": "csv"}
        get "/api/v1/downloads", params, as: :json

        expect(last_response.status).to eq 200
      end
    end

    context "When not logged in" do
      it "returns 401" do
        header "Authentication", ""
        params = {'id': indicator.id, "file_format": "csv"}
        get "/api/v1/downloads", params, as: :json

        expect(last_response.status).to eq 401
      end
    end
  end
end
