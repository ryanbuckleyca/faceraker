module Types
  class MutationType < Types::BaseObject
    field :create_post_mutation, mutation: Mutations::CreatePostMutation
    field :create_user_mutation, mutation: Mutations::CreateUserMutation
    field :create_group_mutation, mutation: Mutations::CreateGroupMutation
    field :create_subscription_mutation, mutation: Mutations::CreateSubscriptionMutation
  end
end
