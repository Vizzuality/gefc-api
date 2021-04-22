class Subgroup < ApplicationRecord
    validates_presence_of :name
    belongs_to :group
    has_many   :indicators
end
