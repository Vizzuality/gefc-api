class Group < ApplicationRecord
    validates_presence_of :name
    has_many :subgroups

    before_create :set_slug

    def set_slug
        self.slug = name.downcase.gsub(/[[:space:]]/, '-')
    end

    def default_subgroup
        subgroups&.first&.name
    end
end
