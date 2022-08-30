require "active_support/concern"

module Slugable
  extend ActiveSupport::Concern

  included do
    before_create :set_slug
  end

  def set_slug
    if self.class == Indicator
      self.slug = "#{sanitaize_name(subgroup.name_en)}-#{sanitaize_name(name_en)}"
    else
      self.slug = sanitaize_name(name_en)
    end
  end

  def sanitaize_name(name)
    name.downcase.strip.gsub(/[[:space:]]/, '-').gsub(/[^\w-]/, '')
  end
end
