class Indicator < ApplicationRecord
    belongs_to :subgroup
    has_many :records
end
