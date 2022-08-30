require "rails_helper"

RSpec.describe API::V1::Regions do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let!(:region1) { create(:region) }
  let!(:geometry1) { create(:geometry_polygon, region: region1) }
  let!(:region2) { create(:region) }
  let!(:geometry2) { create(:geometry_polygon, region: region2) }

  describe "GET Regions" do
    context "when requesting all regions" do
      it "returns 200 and status ok" do
        header "Content-Type", "application/json"
        get "/api/v1/regions"

        expect(last_response.status).to eq(200)
      end

      it "returns a collection of regions with geometries" do
        region1_data = {
          "id" => region1.id,
          "name" => region1.name,
          "region_type" => region1.region_type,
          "geometry" => RGeo::GeoJSON.encode(region1.geometry.geometry)
        }
        region2_data = {
          "id" => region2.id,
          "name" => region2.name,
          "region_type" => region2.region_type,
          "geometry" => RGeo::GeoJSON.encode(region2.geometry.geometry)
        }

        header "Content-Type", "application/json"
        get "/api/v1/regions"

        expect(parsed_body.include?(region1_data)).to eq(true)
        expect(parsed_body.include?(region2_data)).to eq(true)
      end
    end
  end
  describe "GET region" do
    context "when requesting a region" do
      it "returns 200 and status ok" do
        header "Content-Type", "application/json"
        get "/api/v1/regions/#{region1.id}"

        expect(last_response.status).to eq(200)
      end

      it "display the region with geometry" do
        region1_data = {
          "id" => region1.id,
          "name" => region1.name,
          "region_type" => region1.region_type,
          "geometry" => RGeo::GeoJSON.encode(region1.geometry.geometry)
        }

        header "Content-Type", "application/json"
        get "/api/v1/regions/#{region1.id}"
        expect(parsed_body).to eq(region1_data)
      end
    end
  end
end
