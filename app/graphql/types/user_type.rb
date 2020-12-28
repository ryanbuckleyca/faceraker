module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false do
      description "This user's id in this db (not their FB id)"
    end
    field :email, String, null: false do
      description "This user's email."
    end
    field :name, String, null: false do
      description "This user's name."
    end
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When the post was created"
    end
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "Last time post was updated"
    end
  end
end
