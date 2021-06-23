class Indicator < ApplicationRecord
    before_validation :set_by_default, if: :by_default?
    validates_uniqueness_of :by_default, scope: :subgroup_id, if: :by_default?
    
    belongs_to :subgroup
    has_many :records
    has_many :indicator_widgets
    has_many :widgets, through: :indicator_widgets
    #default widget
    belongs_to :widget, optional: true

    scope :by_default, -> { where(by_default: true) }

    # TODO move it into an Indicator creator to avoid realying in callbacks
    #
    def set_by_default
        current_default = subgroup.indicator
        if current_default.present?
            current_default.by_default = false
            current_default.save!
        end
    end
end
