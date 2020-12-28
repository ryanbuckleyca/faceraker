module Mutations
  class CreateSubscriptionMutation < BaseMutation
    field :subscription, Types::SubscriptionType, null: false
    
    argument :id, ID, required: true do
      description "This is the subscription ID."
    end
    argument :group, Types::GroupType, required: true do
      description "The group in this subscription."
    end
    argument :user, Types::UserType, required: true do
      description "The user who is subscribed to this subscription."
    end

    def resolve(id:, group:, user:)
      @subscription = Subscription.new(id: id, group: group, user: user)

      if (@subscription.save)
        {
          subscription: @subscription,
          error: []
        } else {
          subscription: nil,
          errors: @subscription.errors.full_messages
        }
      end
    end
  end
end
