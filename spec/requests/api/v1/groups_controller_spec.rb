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
    let!(:region1) { create(:region) }
    let!(:geometry1) { create(:geometry_polygon, region: region1) }    
    let!(:region2) { create(:region) }
    let!(:geometry2) { create(:geometry_polygon, region: region2) }
    let!(:widget1) { create(:widget, name: 'line') }
    let!(:widget2) { create(:widget, name: 'choropleth') }
    let!(:unit) { create(:unit) }
    let!(:record) { create(:record, indicator: indicator, year: 2020, region: region1, unit: unit) }
    let!(:record2) { create(:record, indicator: indicator, year: 2021, region: region2, unit: unit) }
    let!(:record_widget1) { create(:record_widget, record: record, widget: widget1) }
    let!(:record_widget2) { create(:record_widget, record: record, widget: widget2) }
    let!(:indicator_widget1) { create(:indicator_widget, indicator: indicator, widget: widget1) }
    let!(:indicator_widget2) { create(:indicator_widget, indicator: indicator, widget: widget2) }

    context 'when requesting indicator' do
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}"
        expect(last_response.status).to eq 200
      end
      it 'display the visualization_type for the indicator' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}"
        expect(parsed_body["visualization_types"].include?(widget1.name)).to eq(true)
        expect(parsed_body["visualization_types"].include?(widget2.name)).to eq(true)
      end
    end
  end

  describe 'GET records' do
    let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
    let!(:indicator) { FactoryBot.create(:indicator, subgroup: subgroup) }
    let!(:region1) { create(:region) }
    let!(:geometry1) { create(:geometry_polygon, region: region1) }    
    let!(:region2) { create(:region) }
    let!(:geometry2) { create(:geometry_polygon, region: region2) }
    let!(:widget1) { create(:widget, name: 'line') }
    let!(:widget2) { create(:widget, name: 'choropleth') }
    let!(:unit) { create(:unit) }
    let!(:record) { create(:record, indicator: indicator, year: 2020, region: region1, unit: unit) }
    let!(:record2) { create(:record, indicator: indicator, year: 2021, region: region2, unit: unit) }
    let!(:record_widget1) { create(:record_widget, record: record, widget: widget1) }
    let!(:record_widget2) { create(:record_widget, record: record, widget: widget2) }

    context 'when requesting list of indicator records' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records"

        expect(last_response.status).to eq(200)
      end

      it 'display the scenario name for the records that have one' do
        scenario = create(:scenario)      
        record2.scenario = scenario
        record2.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records"

        expect(find_by_id(record.id)["scenario"]).to eq(nil)
        expect(find_by_id(record2.id)["scenario"]).to eq({"id"=>scenario.id, "name"=>scenario.name})
      end
      it 'display the unit_info for the records' do

        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records"

        expect(find_by_id(record2.id)["unit"]).to eq({"id"=>unit.id, "name"=>unit.name})
      end
      it 'display the region_id for the records' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records"

        expect(find_by_id(record.id)["region_id"]).to eq(region1.id)
        expect(find_by_id(record2.id)["region_id"]).to eq(region2.id)
      end
      it 'display the visualization_type for the records' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records"
        expect(find_by_id(record.id)["visualization_types"].include?(widget1.name)).to eq(true)
        expect(find_by_id(record.id)["visualization_types"].include?(widget2.name)).to eq(true)
      end
    end
  end

  describe 'GET records with filters' do
    let!(:subgroup) { FactoryBot.create(:subgroup, group: group) }
    let!(:indicator) { FactoryBot.create(:indicator, subgroup: subgroup) }
    let!(:record) { create(:record, indicator: indicator, year: 2020, category_1: 'Total') }
    let!(:record2) { create(:record, indicator: indicator, year: 2021, category_1: 'Others') }
    let!(:scenario) { create(:scenario) }
    let!(:region) { create(:region) }
    let!(:unit) { create(:unit) }
    let!(:widget) { FactoryBot.create(:widget, name: 'line') }
    let!(:record_widget) { FactoryBot.create(:record_widget, widget: widget, record: record) }

    context 'with category_1 filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?category_1=Total"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records with the category' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?category_1=Total"
        expect(find_by_id(record.id).present?).to eq(true)
        expect(find_by_id(record2.id).present?).to eq(false)
      end
    end

    context 'with year filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?year=2020"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records for that year' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?year=2020"

        expect(find_by_id(record.id).present?).to eq(true)
        expect(find_by_id(record2.id).present?).to eq(false)
      end
    end

    context 'with start_year filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?start_year=2021"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records starting from that year' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?start_year=2021"

        expect(find_by_id(record.id).present?).to eq(false)
        expect(find_by_id(record2.id).present?).to eq(true)
      end
    end

    context 'with end_year filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?end_year=2020"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records until that year' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?end_year=2020"

        expect(find_by_id(record.id).present?).to eq(true)
        expect(find_by_id(record2.id).present?).to eq(false)
      end
    end

    context 'with years range filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?start_year=2020&end_year=2021"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records within the years range' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?start_year=2020&end_year=2021"

        expect(find_by_id(record.id).present?).to eq(true)
        expect(find_by_id(record2.id).present?).to eq(true)
      end

      it 'does not apply if year filter is present' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?year=2020&start_year=2020&end_year=2021"

        expect(find_by_id(record.id).present?).to eq(true)
        expect(find_by_id(record2.id).present?).to eq(false)
      end
    end

    context 'with scenario filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?scenario=#{scenario.id}"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records with the given scenario' do    
        record2.scenario = scenario
        record2.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?scenario=#{scenario.id}"
        expect(find_by_id(record.id).present?).to eq(false)
        expect(find_by_id(record2.id).present?).to eq(true)
      end
    end
    
    context 'with region filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?region=#{region.id}"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records for the given region' do     
        record2.region = region
        record2.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?region=#{region.id}"
        expect(find_by_id(record.id).present?).to eq(false)
        expect(find_by_id(record2.id).present?).to eq(true)
      end
    end
    
    context 'with unit filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?unit=#{unit.id}"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records for the given unit' do     
        record2.unit = unit
        record2.save!

        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?unit=#{unit.id}"
        expect(find_by_id(record.id).present?).to eq(false)
        expect(find_by_id(record2.id).present?).to eq(true)
      end
    end

    context 'with visualization filter' do      
      it 'returns 200 and status ok' do
        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?visualization=#{widget.name}"

        expect(last_response.status).to eq(200)
      end

      it 'display only the records for the given visualization' do     

        header 'Content-Type', 'application/json'
        get "/api/v1/groups/#{group.id}/subgroups/#{subgroup.id}/indicators/#{indicator.id}/records?visualization=#{widget.name}"
        expect(find_by_id(record.id).present?).to eq(true)
        expect(find_by_id(record2.id).present?).to eq(false)
      end
    end
  end
end
