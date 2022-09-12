require "rails_helper"

RSpec.describe API::V1::Indicators do
  # Rack-Test helper methods like get, post, etc
  include Rack::Test::Methods

  let!(:indicator) { create(:indicator) }
  let!(:region1) { create(:region_polygon) }
  let!(:region2) { create(:region_polygon) }
  let!(:record) { create(:record, indicator: indicator, year: 2020, region: region1) }
  let!(:record2) { create(:record, indicator: indicator, year: 2021, region: region2) }
  sankey_test = {
    "nodes" => [
      {
        "name_en" => "Industry",
        "name_cn" => "工业"
      }
    ],
    "data" => [
      {
        "region_en" => "Kenya",
        "region_cn" => "中國",
        "year" => 2006,
        "units_en" => "10000km",
        "units_cn" => "10000km",
        "links" => [
          {
            "source" => 0,
            "target" => 5,
            "value" => 212778.680352916,
            "class_en" => "Coal",
            "class_cn" => "煤炭"
          },
          {
            "source" => 0,
            "target" => 6,
            "value" => 28151.323772367,
            "class_en" => "Coal",
            "class_cn" => "煤炭"
          }
        ]
      },
      {
        "region_en" => "China",
        "region_cn" => "中國",
        "year" => 2007,
        "units_en" => "10000t",
        "units_cn" => "10000t",
        "links" => [
          {
            "source" => 0,
            "target" => 5,
            "value" => 238262.925413562,
            "class_en" => "Coal",
            "class_cn" => "煤炭"
          },
          {
            "source" => 0,
            "target" => 6,
            "value" => 28981.5535809133,
            "class_en" => "Coal",
            "class_cn" => "煤炭"
          }
        ]
      },
      {
        "region_en" => "China",
        "region_cn" => "中國",
        "year" => 2009,
        "units_en" => "10000t",
        "units_cn" => "10000t",
        "links" => [
          {
            "source" => 0,
            "target" => 5,
            "value" => 248335.422931628,
            "class_en" => "Coal",
            "class_cn" => "煤炭"
          },
          {
            "source" => 0,
            "target" => 6,
            "value" => 30300.9813790703,
            "class_en" => "Coal",
            "class_cn" => "煤炭"
          }
        ]
      }
    ]
  }

  describe "GET indicator" do
    context "when requesting an indicator" do
      it "returns 200 and status ok" do
        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}"

        expect(last_response.status).to eq(200)
      end

      it "display the scenarios" do
        scenario = create(:scenario)
        record2.scenario = scenario
        record2.save!
        # TO DO: this should be updated when a record has scenario. Not here...
        indicator.scenarios = indicator.get_scenarios
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}"

        expect(parsed_body["scenarios"]).to eq([{"id" => scenario.id, "name" => scenario.name}])
      end

      it "display the region_ids" do
        # this is performed in a rake task manually to speed up the import
        # instead of relying in a callback after_Save
        indicator.region_ids = indicator.regions.pluck(:id)
        indicator.save!
        indicator.reload
        # dirty but works

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}"
        expect(parsed_body["region_ids"].include?(region2.id)).to eq(true)
        expect(parsed_body["region_ids"].include?(region1.id)).to eq(true)
      end
    end
  end

  describe "GET records" do
    context "when requesting list of indicator records" do
      it "returns 200 and status ok" do
        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/records"

        expect(last_response.status).to eq(200)
      end

      it "display the scenario name for the records that have one" do
        scenario = create(:scenario)
        record2.scenario = scenario
        record2.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/records"

        expect(find_by_id(record.id)["scenario"]).to eq(nil)
        expect(find_by_id(record2.id)["scenario"]).to eq({"id" => scenario.id, "name" => scenario.name})
      end
    end
  end

  describe "GET sankey" do
    context "when requesting list of indicator records" do
      it "returns 404 if sankey does not exists" do
        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey"

        expect(last_response.status).to eq(404)
      end

      it "returns 200 if sankey exists" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey"

        expect(last_response.status).to eq(200)
      end
      it "returns 200 if sankey exists" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey"

        expect(last_response.status).to eq(200)
      end
      it "response with JSON body containing expected sankey JSON structure" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey"

        expect(last_response.status).to eq(200)

        expect(last_response.body).to look_like_json
        expect(body_as_json.keys).to match_array(["sankey"])
        expect(body_as_json[:sankey].keys).to match_array(["nodes", "data"])
        body_as_json[:sankey][:nodes].each do |node|
          expect(node.keys).to match_array(["name"])
        end
        body_as_json[:sankey][:data].each do |data_item|
          expect(data_item.keys).to match_array(["region", "year", "units", "links"])
          data_item[:links].each do |link|
            expect(link.keys).to match_array(["source", "target", "value", "class"])
          end
        end
      end
    end
    context "filters by year" do
      it "returns 200 and status ok" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?year=2009"

        expect(last_response.status).to eq(200)
      end
      it "response with JSON body containing expected sankey JSON structure" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?year=2009"

        expect(last_response.status).to eq(200)

        expect(last_response.body).to look_like_json
        expect(body_as_json.keys).to match_array(["sankey"])
        expect(body_as_json[:sankey].keys).to match_array(["nodes", "data"])
        body_as_json[:sankey][:nodes].each do |node|
          expect(node.keys).to match_array(["name"])
        end
        body_as_json[:sankey][:data].each do |data_item|
          expect(data_item.keys).to match_array(["region", "year", "units", "links"])
          data_item[:links].each do |link|
            expect(link.keys).to match_array(["source", "target", "value", "class"])
          end
        end
      end
      it "returns only data for that year" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?year=2009"

        expect(JSON.parse(last_response.body)["sankey"]["data"].count).to eq(1)
        expect(JSON.parse(last_response.body)["sankey"]["data"].first["year"]).to eq(2009)
      end
    end
    context "filters by unit" do
      it "returns 200 and status ok" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?unit=10000t"

        expect(last_response.status).to eq(200)
      end
      it "response with JSON body containing expected sankey JSON structure" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?unit=10000t"

        expect(last_response.body).to look_like_json
        expect(body_as_json.keys).to match_array(["sankey"])
        expect(body_as_json[:sankey].keys).to match_array(["nodes", "data"])
        body_as_json[:sankey][:nodes].each do |node|
          expect(node.keys).to match_array(["name"])
        end
        body_as_json[:sankey][:data].each do |data_item|
          expect(data_item.keys).to match_array(["region", "year", "units", "links"])
          data_item[:links].each do |link|
            expect(link.keys).to match_array(["source", "target", "value", "class"])
          end
        end
      end
      it "returns only data for that unit" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?unit=10000t"
        expect(JSON.parse(last_response.body)["sankey"]["data"].count).to eq(2)
        expect(JSON.parse(last_response.body)["sankey"]["data"].first["units"]).to eq("10000t")
      end
    end
    context "filters by region name" do
      it "returns 200 and status ok" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?region=Kenya"

        expect(last_response.status).to eq(200)
      end
      it "response with JSON body containing expected sankey JSON structure" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?region=China"

        expect(last_response.status).to eq(200)

        expect(last_response.body).to look_like_json
        expect(body_as_json.keys).to match_array(["sankey"])
        expect(body_as_json[:sankey].keys).to match_array(["nodes", "data"])
        body_as_json[:sankey][:nodes].each do |node|
          expect(node.keys).to match_array(["name"])
        end
        body_as_json[:sankey][:data].each do |data_item|
          expect(data_item.keys).to match_array(["region", "year", "units", "links"])
          data_item[:links].each do |link|
            expect(link.keys).to match_array(["source", "target", "value", "class"])
          end
        end
      end
      it "returns only data for that region" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?region=China"
        expect(JSON.parse(last_response.body)["sankey"]["data"].count).to eq(2)
        expect(JSON.parse(last_response.body)["sankey"]["data"].first["region"]).to eq("China")
      end
    end
    context "filters by combined params" do
      it "returns 200 and status ok" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?region=China&unit=10000t&year=2009"

        expect(last_response.status).to eq(200)
      end
      it "response with JSON body containing expected sankey JSON structure" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?region=China&unit=10000t&year=2009"

        expect(last_response.status).to eq(200)

        expect(last_response.body).to look_like_json
        expect(body_as_json.keys).to match_array(["sankey"])
        expect(body_as_json[:sankey].keys).to match_array(["nodes", "data"])
        body_as_json[:sankey][:nodes].each do |node|
          expect(node.keys).to match_array(["name"])
        end
        body_as_json[:sankey][:data].each do |data_item|
          expect(data_item.keys).to match_array(["region", "year", "units", "links"])
          data_item[:links].each do |link|
            expect(link.keys).to match_array(["source", "target", "value", "class"])
          end
        end
      end
      it "returns only data matching the combination of params" do
        indicator.sankey = sankey_test
        indicator.save!

        header "Content-Type", "application/json"
        get "/api/v1/indicators/#{indicator.id}/sankey?region=China&unit=10000t&year=2009"
        expect(JSON.parse(last_response.body)["sankey"]["data"].count).to eq(1)
        expect(JSON.parse(last_response.body)["sankey"]["data"].first["region"]).to eq("China")
      end
    end
  end
end
