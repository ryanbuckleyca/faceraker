module Types
  class SubscriptionType < Types::BaseObject
    field :id, ID, null: false do
      description "This subscriptions's id."
    end
    field :group, GroupType, null: false do
      description "This subscription's group."
    end
    field :user, UserType, null: false do
      description "This subscription's user."
    end
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "When the subscription was created"
    end
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false do
      description "Last time subscription was updated"
    end
  end
end
