class Group < ApplicationRecord
    include Slugable
    
    validates_uniqueness_of :name
    validates_presence_of :name

    has_many :subgroups
    has_one :subgroup, ->{ by_default }, class_name: 'Subgroup'

    # Returns subgroup name if exist or nil
    #
    def default_subgroup
        subgroup&.name
    end
end
