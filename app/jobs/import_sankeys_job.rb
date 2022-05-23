class ImportSankeysJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    SandkeysImporter.new.import_from_json(file_path)  
  end
end
