module Types
  class QueryType < Types::BaseObject
    field :posts, [PostType], null: false do
      description "Query that selects all posts"
    end

    field :postsCount, Integer, null: false do
      description "Query that returns total number of posts"
    end

    field :users, [UserType], null: false do
      description "Query that selects all users"
    end

    field :groups, [GroupType], null: false do
      description "Query that selects all groups"
    end

    field :group, [GroupType], null: false do
      argument :id, Integer, required: true
      description "Query that selects a group by ID"
    end

    def posts
      return Post.all
    end

    def groups
      return Group.all
    end

    def group(id: Integer)
      return Group.find_by_id(id)
    end

    def postsCount
      return Post.count
    end

    def users
      return User.all
    end


  end
end
