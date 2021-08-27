require 'rails_helper'

RSpec.describe API::V1::Indicators do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  describe 'GET indicator' do
    context 'when requesting an indicator' do
      let(:indicator) { create(:indicator) }
      let!(:record) { create(:record, indicator: indicator, year: 2020) }
      let!(:record2) { create(:record, indicator: indicator, year: 2021) }
      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}"
        expect(last_response.status).to eq(200)
      end

      it 'display the scenarios' do
        scenario = create(:scenario)      
        record2.scenario = scenario
        record2.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}"
        expect(parsed_body["scenarios"]).to eq([scenario.name])
      end
    end
  end

  describe 'GET records' do
    context 'when requesting list of indicator records' do
      let(:indicator) { create(:indicator) }
      let!(:record) { create(:record, indicator: indicator, year: 2020) }
      let!(:record2) { create(:record, indicator: indicator, year: 2021) }
      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}/records"
        expect(last_response.status).to eq(200)
      end

      it 'display the scenario name for the records that have one' do
        scenario = create(:scenario)      
        record2.scenario = scenario
        record2.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}/records"

        expect(find_by_id(record2.id)["scenario"]).to eq({"name"=>scenario.name})
      end
    end
  end

  describe 'GET regions' do
    context 'when requesting list of indicator regions' do
      let!(:indicator_with_region) { create(:indicator) }
      let!(:region) { create(:region) }
      let!(:geometry) { create(:geometry_polygon, region: region) }
      let!(:record_with_region) { create(:record, indicator: indicator_with_region, year: 2020, region: region) }

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
