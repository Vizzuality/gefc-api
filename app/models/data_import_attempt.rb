class DataImportAttempt < ApplicationRecord
  after_create_commit :import

  enum status: {
    pending: 0,
    running: 1,
    done: 2,
    error: 3
  }

  has_one_attached :original_file

  def status_to_s
    self.status.to_s
  end

  def import
    DataImportJob.perform_async(id)
  end
end
