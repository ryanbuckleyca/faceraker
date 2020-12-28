module Types
  class GroupType < Types::BaseObject
    field :id, ID, null: false do
      description "This group's id."
    end
    field :name, String, null: false do
      description "This group's name."
    end
    field :posts, [PostType], null: true do
      description "Posts from this group."
    end
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When was this group added?"
    end
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When was this group modified?"
    end
  end
end
