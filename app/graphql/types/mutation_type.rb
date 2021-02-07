module Types
  class MutationType < Types::BaseObject
    field :create_post, mutation: Mutations::CreatePost
    field :create_user, mutation: Mutations::CreateUser
    field :create_group, mutation: Mutations::CreateGroup
    field :create_subscription, mutation: Mutations::CreateSubscription
  end
end
