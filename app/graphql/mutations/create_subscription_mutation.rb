module Mutations
  class CreateSubscriptionMutation < BaseMutation
    field :subscription, Types::SubscriptionType, null: false
    
    argument :id, ID, required: true do
      description "This is the subscription ID."
    end
    argument :group_id, Integer, required: true do
      description "The group in this subscription."
    end
    argument :user_id, Integer, required: true do
      description "The user who is subscribed to this subscription."
    end

    def resolve(id:, group_id:, user_id:)
      @subscription = Subscription.new(id: id, group: Group.find_by_id(group_id), user: User.find_by_id(user_id))

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
