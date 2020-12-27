module Types
  class PostType < Types::BaseObject
    field :id, ID, null: false do
      description "This post's id."
    end
    field :title, String, null: true do
      description "This post's title."
    end
    field :body, String, null: true do
      description "This post's body, the main content of post."
    end
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When the post was created"
    end
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "Last time post was updated"
    end
    field :author_id, Integer, null: false do
      description "Id of the post author"
    end
    field :author, AuthorType, null: false do
      description "Author as object"
    end
  end
end
