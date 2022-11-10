require "rails_helper"

RSpec.describe Subgroup, type: :model do
  let(:group) { create(:group) }
  it "is valid with valid attributes" do
    subgroup = build(:subgroup, group: group)

    expect(subgroup).to be_valid
  end
  it "is not valid without a name" do
    subgroup = build(:subgroup, name_en: nil, group: group)

    expect(subgroup).to_not be_valid
  end
  it "has a uniq name within the group" do
    group = create(:group, name_en: "group 1")
    subgroup = create(:subgroup, group: group)
    new_subgroup = build(:subgroup, name_en: subgroup.name_en, group: group)

    expect(new_subgroup).to_not be_valid
  end
  it "can have duplicate name across different groups" do
    group_one = create(:group, name_en: "group 1")
    group_two = create(:group, name_en: "group 2")
    subgroup = create(:subgroup, group: group_one)
    new_subgroup = build(:subgroup, name_en: subgroup.name_en, group: group_two)

    expect(new_subgroup).to be_valid
  end
  it "has a valid slug" do
    subgroup = create(:subgroup)

    expect(subgroup.slug).to eq(Slugable.sanitize_name(subgroup.name_en))
  end
end
