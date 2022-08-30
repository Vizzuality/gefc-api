require "active_support/concern"

module Slugable
  extend ActiveSupport::Concern

  included do
    before_create :set_slug
  end

  def set_slug
    self.slug = if instance_of?(Indicator)
      "#{sanitize_name(subgroup.name_en)}-#{sanitize_name(name_en)}"
    else
      sanitize_name(name_en)
    end
  end

  def sanitize_name(name)
    name.downcase.strip.gsub(/[[:space:]]/, "-").gsub(/[^\w-]/, "")
  end
  module_function :sanitize_name
end
