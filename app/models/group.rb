class Group < ApplicationRecord
    include Slugable
    
    validates_uniqueness_of :name_en
    validates_presence_of :name_en

    has_many :subgroups
    has_one :subgroup, ->{ by_default }, class_name: 'Subgroup'

    translates :name, :description, :subtitle

    # Returns subgroup name if exist or nil
    #
    def default_subgroup
        subgroup&.name
    end

    def self.find_by_id_or_slug!(slug_or_id)
        Group.where('id::TEXT = :id OR slug = :id', id: slug_or_id).first!
    end
end
