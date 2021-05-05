#require 'grape'
require 'grape'

module API
  module V1
    module Entities
    
        class Indicator < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Indicator's unique id"}
            expose :name, documentation: { type: "String", desc: "Indicator's name." }
        end

        class Subgroup < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Subgroup's unique id."}
            expose :name, documentation: { type: "String", desc: "Subgroup's name." }
            expose :indicators, using: API::V1::Entities::Indicator
        end

        class Group < Grape::Entity
            expose :id, documentation: { type: "String", desc: "Group's unique id."}
            expose :name, documentation: { type: "String", desc: "Group's name." }
            expose :subgroups, using: API::V1::Entities::Subgroup
        end      
    end
  end
end