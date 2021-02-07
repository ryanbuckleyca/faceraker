module Mutations
  class CreateUser < BaseMutation
    field :user, Types::UserType, null: false

    argument :id, ID, required: true do
      description "This user's required id. It should not be set manually unlike Group and Post, it is specific to this environment"
    end
    argument :email, String, required: true do
      description "The user's email as string."
    end
    argument :name, String, required: true do
      description "The user's name as string."
    end
    argument :address, String, required: true do
      description "The user's location address as string."
    end

    def resolve(id:, email:, name:)
      @user = User.new(id: id, email: email, name: name, address: address)

      if (@user.save)
        {
          user: @user,
          error: []
        } else {
          user: nil,
          errors: @user.errors.full_messages
        }
      end
    end
  end
end
