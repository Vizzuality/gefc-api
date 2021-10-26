class Group < ApplicationRecord
    include Slugable
    
    validates_uniqueness_of :name_en
    validates_presence_of :name_en
    has_many :subgroups
    # has_many :cached_subgroups, class: "Subgroup"
    has_one :default_subgroup, -> { by_default }, class_name: 'Subgroup'
    has_one_attached :header_image
    translates :name, :description, :subtitle

    def default_subgroup_slug
        default_subgroup_slug = Rails.cache.read("#{self.id}_default_subgroup_slug")
        unless default_subgroup_slug.present?
            default_subgroup_slug = default_subgroup&.slug
            Rails.cache.write("#{self.id}_default_subgroup_slug", default_subgroup_slug, expires_in: 1.day) if default_subgroup_slug.present?
        end

        return default_subgroup_slug
    end

    def self.find_by_id_or_slug!(slug_or_id)
        cached_group = Rails.cache.read("#{slug_or_id}_group")
        unless cached_group.present?
            cached_group = Group.where('id::TEXT = :id OR slug = :id', id: slug_or_id).first!
            Rails.cache.write("#{slug_or_id}_group", cached_group, expires_in: 1.day) if cached_group.present?
        end

        return cached_group
    end

    def header_image_url
        if self.header_image.attachment
            self.header_image.attachment.service_url
        end
    end

    def cached_subgroups
        cached_subgroups = Rails.cache.read("#{self.id}_subgroups")
        unless cached_subgroups.present?
            cached_subgroups = subgroups.to_a
            Rails.cache.write("#{self.id}_subgroups", cached_subgroups, expires_in: 1.day) if cached_subgroups.present?
        end

        return cached_subgroups
    end

end
