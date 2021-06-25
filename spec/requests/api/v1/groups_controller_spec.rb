require 'rails_helper'

RSpec.describe API::V1::Groups do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let!(:group) { FactoryBot.create(:group) }

  describe 'GET groups' do
    context 'when requesting list of groups with no subgroups' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get '/api/v1/groups'
        expect(last_response.status).to eq 200
      end
    end

    context 'when requesting list of groups with subgroups' do
      let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get '/api/v1/groups'
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'GET group' do
    context 'when requesting group with no subgroups' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}"
        expect(last_response.status).to eq 200
      end
    end

    context 'when requesting group with subgroups' do
      let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}"
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'GET subgroups' do
    let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
    context 'when requesting list of subgroups' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups"
        expect(last_response.status).to eq 200
      end
    end
  end

  describe 'GET subgroup' do
    let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
    context 'when requesting subgroup' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}"
        expect(last_response.status).to eq 200
      end
    end
  end
end
