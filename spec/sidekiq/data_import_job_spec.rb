require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe DataImportJob, type: :job do
  Sidekiq::Testing.inline! do
    let(:data_import_attempt) { create(:data_import_attempt) }
    it 'should trigger the import process and fail for an invalid file' do
      importer = DataImportJob.new
      importer.perform(data_import_attempt.id)

      update_data_import = DataImportAttempt.find(data_import_attempt.id)

      expect(update_data_import.status).to eq('error')
      expect(update_data_import.message).to eq("Error importing data: Indicator energy-flows-energy-flows not found")
    end
  end
end
