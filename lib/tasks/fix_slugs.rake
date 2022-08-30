namespace :slugs do
  desc "update slugs for all slugable classes"
  task fix: :environment do
    puts "Groups"
    Group.all.each do |group|
      group.set_slug
      group.save!
    end
    puts "Subgroups"
    Subgroup.all.each do |subgroup|
      subgroup.set_slug
      subgroup.save!
    end
    puts "Indicators"
    Indicator.all.each do |indicator|
      indicator.set_slug
      indicator.save!
    end
    puts "fixed!"
  end
  desc "update slugs for all slugable classes"
  task check: :environment do
    puts "Groups"
    Group.all.each do |group|
      puts group.slug unless group.slug[/[^\w-]/].nil?
    end
    puts "Subgroups"
    Subgroup.all.each do |subgroup|
      puts subgroup.slug unless subgroup.slug[/[^\w-]/].nil?
    end
    puts "Indicators"
    Indicator.all.each do |indicator|
      puts indicator.slug unless indicator.slug[/[^\w-]/].nil?
    end
    puts "checked!"
  end
end
