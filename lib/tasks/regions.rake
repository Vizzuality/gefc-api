namespace :regions do
  desc "Populate geometry encoded"
  task populate_extra_info: :environment do
    Region.all.each do |region|
      puts region.id
      region.geometry_encoded = region.get_geometry_encoded
      region.save!
    end
  end
end
