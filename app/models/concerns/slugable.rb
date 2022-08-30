require "active_support/concern"

module Slugable
  extend ActiveSupport::Concern

  included do
    before_create :set_slug
  end

  def set_slug
    self.slug = if instance_of?(Indicator)
      "#{sanitaize_name(subgroup.name_en)}-#{sanitaize_name(name_en)}"
    else
      sanitaize_name(name_en)
    end
  end

  def sanitaize_name(name)
    name.downcase.strip.gsub(/[[:space:]]/, "-").gsub(/[^\w-]/, "")
  end
end
