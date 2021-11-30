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
  desc "Set nil unit"
  #This task fixes records that have a unit with name nil
  task set_nil_unit: :environment do
    nil_unit = Unit.where(name_en: nil).first
    if nil_unit.present?
      puts "records to change: #{Record.where(unit_id: nil_unit.id)}"
      Record.where(unit_id: nil_unit.id).update_all(unit_id: nil)
      nil_unit.destroy
    else
      puts "nothing to fix"
      puts Record.where(unit_id: nil).count
    end
  end
end
