module Mutations
  class CreatePostMutation < BaseMutation
    field :post, Types::PostType, null: false
    
    argument :id, ID, required: true do
      description "This post's required id. It will autoincrement, but should be set to the FB value"
    end
    argument :group_id, Integer, required: true do
      description "This post's group. It expects a Group type object and is required."
    end
    argument :title, String, required: true do
      description "This post's title. A string, cannot be null"
    end
    argument :price, Integer, required: false do
      description "This price as an integer, if listed, in the post. Sometimes there will not be a price."
    end
    argument :location, String, required: false do
      description "The post's location as string, if any, provided in the post. Sometimes there will not be a location"
    end
    argument :images, String, required: false do
      description "String of Images listed in the post, if any. Sometimes there will not be images."
    end
    argument :text, String, required: true do
      description "The main text of the post. It expects a string and is required."
    end
    argument :link, String, required: true do
      description "Permalink to the post. String should be automatically determined by groupID and postID."
    end

    def resolve(id:, group_id:, title:, price:, location:, images:, text:, link:)
      @post = Post.new(id: id, group: Group.find_by_id(group_id), title: title, price: price, location: location, images: images, text: text, link: link)

      if (@post.save)
        {
          post: @post,
          error: []
        } else {
          post: nil,
          errors: @post.errors.full_messages
        }
      end
    end
  end
end
