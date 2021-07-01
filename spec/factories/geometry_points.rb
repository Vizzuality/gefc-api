FactoryBot.define do
  factory :geometry_point do
    association :region
    geometry {
      RGeo::GeoJSON.decode(
        '{ "type": "Feature", "properties": { "region_cn": "万华化学(烟台)氯碱热电公司", "region_en": "Yantai Wanhua Chlor-alkali Cogen power station", "region_type": "Coal Power Plant" }, "geometry": { "type": "Point", "coordinates": [ 121.0627, 37.69589 ] } }'
      ).geometry
    }
  end
end
