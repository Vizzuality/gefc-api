require 'rails_helper'

RSpec.describe API::V1::Indicators do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let(:indicator) { create(:indicator) }
  let!(:region1) { create(:region) }
  let!(:geometry1) { create(:geometry_polygon, region: region1) }    
  let!(:region2) { create(:region) }
  let!(:geometry2) { create(:geometry_polygon, region: region2) }
  let!(:record) { create(:record, indicator: indicator, year: 2020, region: region1) }
  let!(:record2) { create(:record, indicator: indicator, year: 2021, region: region2) }

  describe 'GET indicator' do
    context 'when requesting an indicator' do      
      it 'returns 200 and status ok' do

        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}"

        expect(last_response.status).to eq(200)
      end

      it 'display the scenarios' do
        scenario = create(:scenario)      
        record2.scenario = scenario
        record2.save!
        # TO DO: this should be updated when a record has scenario. Not here...
        indicator.scenarios = indicator.get_scenarios
        indicator.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}"

        expect(parsed_body["scenarios"]).to eq([scenario.name])
      end

      it 'display the region_ids' do
        header 'Content-Type', 'application/json'
        get "/api/v1/indicators/#{indicator.id}"
        expect(parsed_body["region_ids"].include?(region2.id)).to eq(true)
        expect(parsed_body["region_ids"].include?(region1.id)).to eq(true)
      end
    end
  end

  describe 'GET records' do
    context 'when requesting list of indicator records' do      
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

        expect(find_by_id(record.id)["scenario"]).to eq(nil)
        expect(find_by_id(record2.id)["scenario"]).to eq({"name"=>scenario.name})
      end
    end
  end
end
