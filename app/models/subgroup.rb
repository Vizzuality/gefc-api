class Subgroup < ApplicationRecord
  include Slugable

  validates_uniqueness_of :by_default, scope: :group_id, if: :by_default?
  validates_uniqueness_of :name_en, scope: :group_id
  validates_presence_of :name_en

  belongs_to :group
  has_many :indicators
  has_one :default_indicator, -> { by_default }, class_name: "Indicator"

  scope :by_default, -> { where(by_default: true) }

  translates :name, :description

  def self.find_by_id_or_slug!(slug_or_id, filters)
    API::V1::FetchSubgroup.new.by_id_or_slug(slug_or_id, filters)
  end

  def cached_default_indicator
    API::V1::FetchIndicator.new.default_by_subgroup(self)
  end

  def cached_indicators
    API::V1::FetchIndicator.new.by_subgroup(self)
  end
end
