# require 'grape'
require "grape"

module API
  module V1
    module Entities
      class RegionWithGeometries < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Region's unique id"}
        expose :name, documentation: {type: "String", desc: "Region's name."}
        expose :region_type, documentation: {type: "String", desc: "Region type."}
        expose :geometry_encoded, as: :geometry
      end

      class Region < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Region's unique id"}
        expose :name, documentation: {type: "String", desc: "Region's name."}
        expose :region_type, documentation: {type: "String", desc: "Region type."}
      end

      class Scenario < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Scenario's unique id"}
        expose :name, documentation: {type: "String", desc: "Scenario's name."}
      end

      class Unit < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Unit's unique id"}
        expose :name, documentation: {type: "String", desc: "Unit's name."}
      end

      class Record < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Record's unique id"}
        expose :value, documentation: {type: "String", desc: "Record's name."}
        expose :year, documentation: {type: "String", desc: "Record's year."}
        expose :file, documentation: {type: "String", desc: "Record's file name."}
        expose :category_1, documentation: {type: "String", desc: "Record's category."}
        expose :category_2, documentation: {type: "String", desc: "Record's category."}
        expose :unit, using: API::V1::Entities::Unit
        expose :region_id
        expose :scenario, using: API::V1::Entities::Scenario
        expose :visualization_types, as: :visualization_types
      end

      class IndicatorWithNestedData < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Indicator's unique id"}
        expose :slug, documentation: {type: "String", desc: "Indicator's slug."}
        expose :name, documentation: {type: "String", desc: "Indicator's name."}
        expose :description, documentation: {type: "String", desc: "Indicator's description."}
        expose :default_visualization_name, as: :default_visualization
        expose :only_admins_can_download
        expose :visualization_types, as: :visualization_types
        expose :category_1, as: :categories
        expose :category_filters, as: :category_filters
        expose :start_date, as: :start_date
        expose :end_date, as: :end_date
        expose :scenarios, as: :scenarios
        expose :data_source, as: :data_source
        expose :region_ids, as: :region_ids
        expose :records, using: API::V1::Entities::Record
      end

      class Indicator < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Indicator's unique id"}
        expose :slug, documentation: {type: "String", desc: "Indicator's slug."}
        expose :name, documentation: {type: "String", desc: "Indicator's name."}
        expose :description, documentation: {type: "String", desc: "Indicator's description."}
        expose :default_visualization_name, as: :default_visualization
        expose :only_admins_can_download
        expose :visualization_types, as: :visualization_types
        expose :category_1, as: :categories
        expose :category_filters, as: :category_filters
        expose :start_date, as: :start_date
        expose :end_date, as: :end_date
        expose :scenarios, as: :scenarios
        expose :data_source, as: :data_source
        expose :region_ids, as: :region_ids
      end

      class FullIndicator < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Indicator's unique id"}
        expose :slug, documentation: {type: "String", desc: "Indicator's slug."}
        expose :name, documentation: {type: "String", desc: "Indicator's name."}
        expose :description, documentation: {type: "String", desc: "Indicator's description."}
        expose :default_visualization_name, as: :default_visualization
        expose :only_admins_can_download
        expose :visualization_types, as: :visualization_types
        expose :categories, as: :categories
        expose :category_filters, as: :category_filters
        expose :start_date, as: :start_date
        expose :end_date, as: :end_date
        expose :subgroup, using: "API::V1::Entities::MinimumSubgroup"
        expose :group, using: "API::V1::Entities::MinimumGroup"
        expose :scenarios, as: :scenarios
        expose :data_source, as: :data_source
        expose :region_ids, as: :region_ids
      end

      class SubgroupWithNestedData < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Subgroup's unique id."}
        expose :slug, documentation: {type: "String", desc: "Subgroup's slug."}
        expose :name, documentation: {type: "String", desc: "Subgroup's name."}
        expose :description, documentation: {type: "String", desc: "Subgroup's description."}
        expose :cached_indicators, as: :indicators, using: API::V1::Entities::IndicatorWithNestedData
        expose :cached_default_indicator, as: :default_indicator, using: API::V1::Entities::IndicatorWithNestedData
      end

      class FullSubgroup < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Subgroup's unique id."}
        expose :slug, documentation: {type: "String", desc: "Subgroup's slug."}
        expose :name, documentation: {type: "String", desc: "Subgroup's name."}
        expose :description, documentation: {type: "String", desc: "Subgroup's description."}
        expose :cached_indicators, as: :indicators, using: API::V1::Entities::Indicator
        expose :cached_default_indicator, as: :default_indicator, using: API::V1::Entities::Indicator
      end

      class MinimumSubgroup < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Subgroup's unique id."}
        expose :slug, documentation: {type: "String", desc: "Subgroup's slug."}
        expose :name, documentation: {type: "String", desc: "Subgroup's name."}
      end

      class BasicSubgroup < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Subgroup's unique id."}
        expose :slug, documentation: {type: "String", desc: "Subgroup's slug."}
        expose :name, documentation: {type: "String", desc: "Subgroup's name."}
        expose :cached_default_indicator, as: :default_indicator, using: API::V1::Entities::Indicator
      end

      class Group < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Group's unique id."}
        expose :slug, documentation: {type: "String", desc: "Group's slug."}
        expose :name, documentation: {type: "String", desc: "Group's name."}
        expose :subtitle, documentation: {type: "String", desc: "Group's name."}
        expose :description, documentation: {type: "String", desc: "Group's description."}
        expose :default_subgroup_slug, as: :default_subgroup
        expose :cached_subgroups, as: :subgroups, using: API::V1::Entities::BasicSubgroup
      end

      class GroupWithNestedData < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Group's unique id."}
        expose :slug, documentation: {type: "String", desc: "Group's slug."}
        expose :name, documentation: {type: "String", desc: "Group's name."}
        expose :subtitle, documentation: {type: "String", desc: "Group's name."}
        expose :description, documentation: {type: "String", desc: "Group's description."}
        expose :default_subgroup_slug, as: :default_subgroup
        expose :cached_subgroups, as: :subgroups, using: API::V1::Entities::SubgroupWithNestedData
      end

      class MinimumGroup < Grape::Entity
        expose :id, documentation: {type: "String", desc: "Group's unique id."}
        expose :slug, documentation: {type: "String", desc: "Group's slug."}
        expose :name, documentation: {type: "String", desc: "Group's name."}
      end

      class UserWithJWT < Grape::Entity
        expose :email, documentation: {type: "String", desc: "User's email."}
        expose :name, documentation: {type: "String", desc: "User's name."}
        expose :organization, documentation: {type: "String", desc: "User's organization."}
        expose :title, documentation: {type: "String", desc: "User's title."}
        expose :jwt_token, as: :jwt_token
      end

      class UserInfo < Grape::Entity
        expose :email, documentation: {type: "String", desc: "User's email."}
        expose :name, documentation: {type: "String", desc: "User's username."}
        expose :organization, documentation: {type: "String", desc: "User's organization."}
        expose :title, documentation: {type: "String", desc: "User's title."}
        expose :role, documentation: {type: "String", desc: "User's role"}
      end

      class IndicatorMeta < Grape::Entity
        expose(:meta) { |item, options| item.meta_by_locale(options[:locale]) }
      end

      class IndicatorSankey < Grape::Entity
        expose(:sankey) { |item, options| item.sankey_by_locale(options[:locale], options[:year], options[:unit], options[:region]) }
      end
    end
  end
end
