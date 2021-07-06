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
end
