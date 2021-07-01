class Group < ApplicationRecord
    include Slugable
    
    validates_uniqueness_of :name_en
    validates_presence_of :name_en

    has_many :subgroups
    has_one :default_subgroup, -> { by_default }, class_name: 'Subgroup'

    translates :name, :description, :subtitle

    def default_subgroup_slug
        default_subgroup&.slug
    end
end
