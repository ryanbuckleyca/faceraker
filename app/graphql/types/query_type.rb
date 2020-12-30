module Types
  class QueryType < Types::BaseObject
    field :posts, [PostType], null: false do
      description "Query that selects all posts"
    end

    field :postsCount, Integer, null: false do
      description "Query that returns total number of posts"
    end

    field :users, [UserType], null: false do |variable|
      description "Query that selects all users"
    end

    def posts
      return Post.all
    end

    def postsCount
      return Post.count
    end

    def users
      return User.all
    end


  end
end
