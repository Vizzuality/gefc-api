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
  it "has a uniq name" do
    subgroup = create(:subgroup)
    new_subgroup = build(:subgroup, name: subgroup.name)

    expect(new_subgroup).to_not be_valid
  end
  it "has a valid slug" do
    subgroup = create(:subgroup)

    expect(subgroup.slug).to eq(subgroup.name.downcase.gsub(/[[:space:]]/, '-'))
  end
end
