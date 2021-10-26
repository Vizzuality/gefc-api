class Subgroup < ApplicationRecord
    include Slugable

    validates_uniqueness_of :by_default, scope: :group_id, if: :by_default?
    validates_uniqueness_of :name_en
    validates_presence_of :name_en
    
    belongs_to :group
    has_many :indicators
    has_one :default_indicator, -> { by_default }, class_name: 'Indicator'
    has_one :cached_default_indicator, class_name: 'Indicator'

    scope :by_default, -> { where(by_default: true) }

    translates :name, :description

    def self.find_by_id_or_slug!(slug_or_id, filters)
        cached_subgroup = Rails.cache.read("#{slug_or_id}_subgroup")
        unless cached_subgroup.present?
            cached_subgroup = Subgroup.
            where('id::TEXT = :id OR slug = :id', id: slug_or_id).
            where(filters).
            first!
            Rails.cache.write("#{slug_or_id}_subgroup", cached_subgroup, expires_in: 1.day) if cached_subgroup.present?
        end

        return cached_subgroup
    end

    def cached_default_indicator
        cached_default_indicator = Rails.cache.read("#{self.id}_cached_default_indicator")
        unless cached_default_indicator.present?
            cached_default_indicator = default_indicator
            Rails.cache.write("#{self.id}_cached_default_indicator", cached_default_indicator, expires_in: 1.day) if cached_default_indicator.present?
        end

        return cached_default_indicator
    end
end
