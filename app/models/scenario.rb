class Scenario < ApplicationRecord
  validates_uniqueness_of :name_en
  validates_presence_of :name_en
  
  has_many :records

  translates :name
end
