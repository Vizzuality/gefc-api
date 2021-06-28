class Region < ApplicationRecord
    has_many :records

    translates :name

    enum region_type: [:other, :global, :continent, :country, :province, :coal_plant]
end
