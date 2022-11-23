class RegionsExtraInfo
  def populate
    Parallel.map(Region.all) do |region|
      puts region.id
      region.geometry_encoded = region.get_geometry_encoded
      region.save!
    end
  end
end
