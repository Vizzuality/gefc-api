class Group < ApplicationRecord
  include Slugable

  validates_uniqueness_of :name_en
  validates_presence_of :name_en
  has_many :subgroups
  has_one :default_subgroup, -> { by_default }, class_name: "Subgroup"
  translates :name, :description, :subtitle

  def default_subgroup_slug
    API::V1::FetchSubgroup.new.default_slug_by_group(self)
  end

  def self.find_by_id_or_slug!(slug_or_id)
    API::V1::FetchGroup.new.by_id_or_slug(slug_or_id)
  end

  def cached_subgroups
    API::V1::FetchSubgroup.new.by_group(self)
  end
end
