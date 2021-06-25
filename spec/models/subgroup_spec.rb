require 'rails_helper'

RSpec.describe Subgroup, type: :model do
  let(:group) { create(:group) }
  it "is valid with valid attributes" do
    subgroup = build(:subgroup, name: "my first subgroup", group: group)

    expect(subgroup).to be_valid
  end

  it "is not valid without a name" do
    subgroup = build(:subgroup, name: nil, group: group)

    expect(subgroup).to_not be_valid
  end
end
