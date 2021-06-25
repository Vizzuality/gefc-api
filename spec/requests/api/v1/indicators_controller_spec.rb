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
        expect(last_response.status).to eq 200
      end
    end
  end
end
