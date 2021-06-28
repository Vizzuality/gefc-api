class Group < ApplicationRecord
    before_create :set_slug
    
    validates_uniqueness_of :name
    validates_presence_of :name

    has_many :subgroups
    has_one :subgroup, ->{ by_default }, class_name: 'Subgroup'

    def set_slug
        self.slug = name.downcase.gsub(/[[:space:]]/, '-')
    end

    def default_subgroup
        subgroup.name
    end
end
