require "active_support/concern"

module Slugable
  extend ActiveSupport::Concern

  included do
    before_create :set_slug
  end

  def set_slug
    if self.class == Indicator
      self.slug = "#{subgroup.name_en.downcase.gsub(/[[:space:]]/, '-')}-#{name_en.downcase.gsub(/[[:space:]]/, '-')}"
    else
      self.slug = name_en.downcase.gsub(/[[:space:]]/, '-')
    end
  end
end
