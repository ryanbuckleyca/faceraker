module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false do
      description "This post's id."
    end
    field :group, GroupType, null: false do
      description "This post's group."
    end
    field :title, String, null: false do
      description "This post's title."
    end
    field :price, Float, null: true do
      description "This price, if listed, in the post."
    end
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When the post was created"
    end
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "Last time post was updated"
    end
    field :location, String, null: true do
      description "The post's location, if any, provided in the post."
    end
    field :longitude, Float, null: true do
      description "The longitude determined by geocoder gem based on location field"
    end
    field :latitude, Float, null: true do
      description "The latitude determined by geocoder gem based on location field"
    end
    field :images, String, null: true do
      description "Images listed in the post, if any"
    end
    field :text, String, null: false do
      description "The main text of the post."
    end
    field :link, String, null: false do
      description "Permalink to the post."
    end
  end
end
