class Subgroup < ApplicationRecord
    before_validation :set_by_default, if: :by_default?
    validates_uniqueness_of :by_default, scope: :group_id, if: :by_default?
    validates_presence_of :name
    
    belongs_to :group
    has_many :indicators
    has_one :indicator, ->{ by_default }, class_name: 'Indicator'

    scope :by_default, -> { where(by_default: true) }

    translates :name, :description

    # TODO move it into a Subgroup creator to avoid realying in callbacks
    #
    def set_by_default
        current_default = group.subgroup
        if current_default.present?
            current_default.by_default = false
            current_default.save!
        end
    end
end
