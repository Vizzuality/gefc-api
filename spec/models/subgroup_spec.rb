require 'rails_helper'

RSpec.describe Subgroup, type: :model do
  it "is valid with valid attributes" do
    new_group = create(:group)
    valid_params = { name: "my first subgroup", group: new_group }

    expect(Subgroup.new(valid_params)).to be_valid
  end
  it "is not valid without a name" do
    new_group = create(:group)
    group = Subgroup.new(name: nil, group: new_group )
    
    expect(group).to_not be_valid
  end
end
