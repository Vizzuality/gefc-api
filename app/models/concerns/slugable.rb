require "active_support/concern"

module Slugable
  extend ActiveSupport::Concern

  included do
    before_create :set_slug
  end

  def set_slug
    self.slug = name_en.downcase.gsub(/[[:space:]]/, '-')
  end
end
