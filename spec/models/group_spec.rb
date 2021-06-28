require 'rails_helper'

RSpec.describe Group, type: :model do
  it "is valid with valid attributes" do
    new_group = build(:group)

    expect(new_group).to be_valid
  end
  it "is not valid without a name" do
    group = build(:group, name: nil)

    expect(group).to_not be_valid
  end
  it "has a uniq name" do
    group = create(:group)
    new_group = build(:group, name: group.name)

    expect(new_group).to_not be_valid
  end
  it "has a valid slug" do
    group = create(:group)

    expect(group.slug).to eq(group.name.downcase.gsub(/[[:space:]]/, '-'))
  end
end
