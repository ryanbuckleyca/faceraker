module Mutations
  class CreateGroup < BaseMutation
    field :group, Types::GroupType, null: false
    
    argument :id, ID, required: true do
      description "This group's required id. It should be set manually to the FB group ID"
    end
    argument :name, String, required: true do
      description "The group's name as string."
    end

    def resolve(id:, name:)
      @group = Group.new(id: id, name: name)

      if (@group.save)
        {
          group: @group,
          error: []
        } else {
          group: nil,
          errors: @group.errors.full_messages
        }
      end
    end
  end
end
