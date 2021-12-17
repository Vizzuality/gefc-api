namespace :subgroups do
  desc "search_duplicates"
  task search_duplicates: :environment do
    subgroups_by_name = {}
    Subgroup.all.each do |subgroup|
      unless subgroups_by_name[subgroup.name_en.downcase].nil?
        subgroups_by_name[subgroup.name_en.downcase].push(subgroup.id)
      else
        subgroups_by_name[subgroup.name_en.downcase] = [subgroup.id]
      end
    end

    subgroups_by_name.each do |key, value| 
      if value.count > 1
        first_subgroup = Subgroup.find(value.first)
        second_subgroup = Subgroup.find(value.second)

        puts first_subgroup.indicators.count
        puts "*********************"
        puts second_subgroup.indicators.count

        second_subgroup.indicators.each do |indicator|
          indicator.by_default = false if indicator.by_default?
          indicator.subgroup = first_subgroup
          indicator.save!
        end

        puts first_subgroup.indicators.count
        puts "*********************"
        puts second_subgroup.indicators.count
        second_subgroup.destroy
      end
    end
  end
end
