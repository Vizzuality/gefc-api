namespace :records do
  desc "Populate extra info"
  task populate_extra_info: :environment do
    Record.all.each do |record|
      puts record.id
      if record.visualization_types.nil? or record.visualization_types.blank?
        puts "blank"
        record.visualization_types = record.widgets_list
        record.save!
      else
        puts "done!"
      end
    end
  end
end
