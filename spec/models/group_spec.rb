require 'rails_helper'

RSpec.describe Group, type: :model do
  it "is valid with valid attributes" do
    new_group = create(:group)

    expect(new_group).to be_valid
  end
  it "is not valid without a name" do
    group = Group.new(name: nil)
    
    expect(group).to_not be_valid
  end
end
