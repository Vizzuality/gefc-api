require 'rails_helper'

RSpec.describe API::V1::Groups do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let!(:group) { FactoryBot.create(:group) }

  describe 'GET groups' do
    context 'when requesting list of groups with no subgroups' do
      let!(:groups) { FactoryBot.create_list(:group, 3) }
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get '/api/v1/groups'
        expect(last_response.status).to eq 200
      end
      it 'returns a list of groups ordered by english name' do
        header 'Content-Type', 'application/json'
        get '/api/v1/groups'
        parsed_body = JSON.parse(last_response.body)

        expect(parsed_body.first["id"]).to eq Group.all.order(:name_en).first.id
        expect(parsed_body.count).to eq Group.all.order(:name_en).count
        expect(parsed_body.last["id"]).to eq Group.all.order(:name_en).last.id
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
    let!(:subgroups) { FactoryBot.create_list(:subgroup, 3, group: group) }
    context 'when requesting list of subgroups' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups"
        expect(last_response.status).to eq 200
      end
      it 'returns a list of subgroups ordered by english name' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups"
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body.first["id"]).to eq Subgroup.all.order(:name_en).first.id
        expect(parsed_body.count).to eq Subgroup.all.order(:name_en).count
        expect(parsed_body.last["id"]).to eq Subgroup.all.order(:name_en).last.id
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

  describe 'GET indicators' do
    let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
    let!(:indicators) { FactoryBot.create_list(:indicator, 3, subgroup: subgroup) }
    context 'when requesting list of indicators' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators"
        expect(last_response.status).to eq 200
      end
      it 'returns a list of indicators ordered by english name' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators"
        parsed_body = JSON.parse(last_response.body)
        expect(parsed_body.first["id"]).to eq Indicator.all.order(:name_en).first.id
        expect(parsed_body.count).to eq Indicator.all.order(:name_en).count
        expect(parsed_body.last["id"]).to eq Indicator.all.order(:name_en).last.id
      end
    end
  end

  describe 'GET indicator' do
    let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
    let!(:indicator) { FactoryBot.create(:indicator, subgroup: subgroup) }
    context 'when requesting indicator' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}"
        expect(last_response.status).to eq 200
      end
    end
  end
end
