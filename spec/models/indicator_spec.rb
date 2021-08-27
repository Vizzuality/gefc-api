require 'rails_helper'

RSpec.describe Indicator, type: :model do
  it "returns an array of records category without repited elements" do
    indicator = create(:indicator)
    record_1 = create(:record, indicator: indicator, category_1: "category one")
    record_2 = create(:record, indicator: indicator, category_1: "category one")
    record_3 = create(:record, indicator: indicator, category_1: "category two")

    expect(indicator.category_1).to eq([record_1.category_1, record_3.category_1])
  end
  it "returns an array with records category_2 for each category_1" do
    indicator = create(:indicator)
    category_one = "category one"
    category_two = "category two"

    record_1 = create(:record, indicator: indicator, category_1: category_one, category_2: "filter one")
    record_2 = create(:record, indicator: indicator, category_1: category_one, category_2: "another filter")
    record_3 = create(:record, indicator: indicator, category_1: category_two, category_2: "filter two")
  
    expect(indicator.category_filters).to eq({ category_one => [record_1.category_2, record_2.category_2], category_two => [record_3.category_2] })
  end

  describe :regions do
    it "returns a collection of records regions without duplications" do
      indicator = create(:indicator)
      region_1 = create(:region)
      region_2 = create(:region)
      record_1 = create(:record, indicator: indicator, region: region_1)
      record_2 = create(:record, indicator: indicator, region: region_1)
      record_3 = create(:record, indicator: indicator, region: region_2)
      
      expect(indicator.regions.include?(region_1)).to eq(true)
      expect(indicator.regions.include?(region_2)).to eq(true)
      expect(indicator.regions.count).to eq(2)
    end

    it "rises and exception if there are no regions" do
      indicator = create(:indicator)

      expect { indicator.regions }.to raise_error(IndicatorRegionException)
    end
  end

  describe :scenario do
    it "returns an array with the names of the scenarios" do
      indicator = create(:indicator)
      scenario_1 = create(:scenario)
      scenario_2 = create(:scenario, name:"scenario 2")
      record_1 = create(:record, indicator: indicator, scenario: scenario_1)
      record_2 = create(:record, indicator: indicator, scenario: scenario_2)
      record_3 = create(:record, indicator: indicator)
      
      expect(indicator.scenarios.include?(scenario_1.name)).to eq(true)
      expect(indicator.scenarios.include?(scenario_2.name)).to eq(true)
      expect(indicator.scenarios.count).to eq(2)
            
    end
  end
end
