class Scenario < ApplicationRecord
  validates_uniqueness_of :name
  has_many :records
end
