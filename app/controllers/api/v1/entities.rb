#require 'grape'
require 'grape'

module API
  module V1
    module Entities
    
        class Region < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Region's unique id" }
            expose :name, documentation: { type: "String", desc: "Region's name." }
            expose :region_type, documentation: { type: "String", desc: "Region type." }
        end
        class Unit < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Unit's unique id" }
            expose :name, documentation: { type: "String", desc: "Unit's name." }
        end
        class Record < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Record's unique id" }
            expose :value, documentation: { type: "String", desc: "Record's name." }
            expose :year, documentation: { type: "String", desc: "Record's year." }
            expose :category_1, documentation: { type: "String", desc: "Record's category." }
            expose :category_2, documentation: { type: "String", desc: "Record's category." }
            expose :unit, using: API::V1::Entities::Unit
            expose :region, using: API::V1::Entities::Region
        end
        class Indicator < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Indicator's unique id" }
            expose :name, documentation: { type: "String", desc: "Indicator's name." }
            expose :description, documentation: { type: "String", desc: "Indicator's description." }
            expose :published, documentation: { type: "Boolean", desc: "Indicator's published status." }
        end
        class FullIndicator < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Indicator's unique id" }
            expose :name, documentation: { type: "String", desc: "Indicator's name." }
            expose :description, documentation: { type: "String", desc: "Indicator's description." }
            expose :published, documentation: { type: "Boolean", desc: "Indicator's published status." }
            expose :records, using: API::V1::Entities::Record
        end

        class Subgroup < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Subgroup's unique id." }
            expose :name, documentation: { type: "String", desc: "Subgroup's name." }
            expose :description, documentation: { type: "String", desc: "Subgroup's description." }
            expose :published, documentation: { type: "Boolean", desc: "Subgroup's published status." }
            expose :indicators, using: API::V1::Entities::Indicator
        end

        class Group < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Group's unique id." }
            expose :slug, documentation: { type: "String", desc: "Group's slug." }
            expose :name, documentation: { type: "String", desc: "Group's name." }
            expose :subtitle, documentation: { type: "String", desc: "Group's name." }
            expose :description, documentation: { type: "String", desc: "Group's description." }
            expose :published, documentation: { type: "Boolean", desc: "Group's published status." }
            expose :subgroups, using: API::V1::Entities::Subgroup
        end 
    end
  end
end