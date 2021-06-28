class Region < ApplicationRecord
    has_many :records

    translates :name
end
