require "rails_helper"

RSpec.describe Region, type: :model do
  let(:coal_power_plant) {
    create(:region, region_type: :coal_power_plant, geometry_point: create(:geometry_point))
  }
  let(:province) {
    create(:region, region_type: :province, geometry_polygon: create(:geometry_polygon))
  }
  let(:region_without_geometry) {
    create(:region, region_type: :province)
  }

  describe :geometry do
    it "has point geometry if it's a coal power plant" do
      expect(coal_power_plant.geometry).to be_a(GeometryPoint)
    end

    it "has polygon geometry if it's a province" do
      expect(province.geometry).to be_a(GeometryPolygon)
    end

    it "raises an exception if there is no geometry" do
      expect { region_without_geometry.geometry }.to raise_error(GeometryException)
    end
  end

  describe :geometry_encoded do
    it "returns the encoded version of the geometry" do
      geometry_encoded = RGeo::GeoJSON.encode(province.geometry.geometry)

      expect(province.get_geometry_encoded).to eq(geometry_encoded)
    end
    it "returns nil if there is no geometry" do
      expect(region_without_geometry.get_geometry_encoded).to eq(nil)
    end
  end
end
