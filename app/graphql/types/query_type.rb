module Types
  class QueryType < Types::BaseObject
    field :posts, [PostType], null: true do
      description "Query that selects all posts"
    end

    field :post, PostType, null: true do
      argument :id, ID, required: true
      description "Query that selects a specific post by ID"
    end

    field :postsCount, Integer, null: true do
      description "Query that returns total number of posts"
    end

    field :users, [UserType], null: true do
      description "Query that selects all users"
    end

    field :groups, [GroupType], null: true do
      description "Query that selects all groups"
    end

    field :group, GroupType, null: true do
      argument :id, ID, required: true
      description "Query that selects a group by ID"
    end

    def posts
      return Post.all
    end

    def post(id: ID)
      return Post.find_by_id(id)
    end

    def groups
      return Group.all
    end

    def group(id: ID)
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
