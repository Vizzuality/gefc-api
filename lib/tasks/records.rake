namespace :records do
  desc "Populate extra info"
  task populate_extra_info: :environment do
    Record.all.each do |record|
      record.visualization_types = record.widgets_list
      record.save!
    end
  end
end
