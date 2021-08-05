require 'rails_helper'

RSpec.describe API::V1::Indicators do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let(:indicator) { create(:indicator) }
  let!(:record1) { create(:record, indicator: indicator, year: 2020) }
  let!(:record2) { create(:record, indicator: indicator, year: 2021) }

  describe 'GET records' do
    context 'when requesting list of indicator records' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}/records"
        expect(last_response.status).to eq(200)
      end
    end
  end

  describe 'GET regions' do
    context 'when requesting list of indicator regions' do
      let!(:indicator_with_region) { create(:indicator) }
      let!(:region) { create(:region) }
      let!(:geometry) { create(:geometry_polygon, region: region) }
      let!(:record1) { create(:record, indicator: indicator_with_region, year: 2020, region: region) }

      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator_with_region.id}/regions"
        expect(last_response.status).to eq(200)
      end

      it 'returns a collection of regions with geometries' do
        region_data = {
          "id"=> region.id,
          "name"=> region.name,
          "region_type"=> region.region_type,
          "geometry"=> RGeo::GeoJSON.encode(region.geometry.geometry)
        }
        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator_with_region.id}/regions"
        expect(parsed_body.include?(region_data)).to eq(true)
      end

      it 'returns an error message if there are no regions for this indicator' do
        indicator_without_records_or_region = create(:indicator)

        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator_without_records_or_region.id}/regions"
        expect(parsed_body["error"].nil?).to eq(false)
        expect(last_response.status).to eq(404)
      end
    end
  end
end
