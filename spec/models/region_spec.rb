require 'rails_helper'

RSpec.describe Region, type: :model do
  let(:coal_power_plant) {
    create(:region, region_type: :coal_power_plant, geometry_point: create(:geometry_point))
  }
  let(:province) {
    create(:region, region_type: :province, geometry_polygon: create(:geometry_polygon))
  }

  describe :geometry do
    it "has point geometry if it's a coal power plant" do
      expect(coal_power_plant.geometry).to be_a(GeometryPoint)
    end

    it "has polygon geometry if it's a province" do
      expect(province.geometry).to be_a(GeometryPolygon)
    end
  end
end
