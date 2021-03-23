class Record < ApplicationRecord
    belongs_to :indicator
    belongs_to :unit
    belongs_to :region
end
