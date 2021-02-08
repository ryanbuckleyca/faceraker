desc 'Fetch ads'
task :fetch_ads => :environment do
  require 'rubygems'
  require 'mechanize'
  require 'dotenv'
  require 'json'
  require "graphql/client"
  require "graphql/client/http"

  module SWAPI
    # HTTP = GraphQL::Client::HTTP.new("http://louwer-api.herokuapp.com/graphql")
    HTTP = GraphQL::Client::HTTP.new("http://localhost:8000/graphql")
    Schema = GraphQL::Client.load_schema(HTTP)
    Client = GraphQL::Client.new(schema: Schema, execute: HTTP)
  end

  CreatePost = SWAPI::Client.parse <<-'GRAPHQL'
    mutation($data: CreatePostInput!) { 
      createPost(input: $data) {
        post {
          id
          group { id, name }
          title
          price
          location
          longitude
          latitude
          images
          text
          link
        }
      }
    }
  GRAPHQL

  PostByID = SWAPI::Client.parse <<-'GRAPHQL'
    query($id: ID!) { 
      post(id: $id) {
        id
      }
    }
  GRAPHQL

  agent = Mechanize.new
  agent.user_agent = 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36'
  agent.get('https://m.facebook.com/')
  login_form = agent.page.form_with(:method => 'POST')
  login_form.email = 'ryanbuckley@gmail.com'
  puts "env is loaded" if ENV['FB_PASS']
  login_form.pass = ENV['FB_PASS']
  agent.submit(login_form)

  # add check to see if Not Now even exists first?
  agent.page.link_with(:text => 'Not Now').click

  # app could be expanded to mutliple groups
  group = '263590541122539'

  cessation_page = agent.get("https://www.facebook.com/groups/#{group}")
  cessation_page.css("div[role='article']").each_with_index do |post, i|
    puts "--------- AD ##{i + 1} -----------"

    id = JSON.parse(post['data-ft'])['mf_story_key']
    record_exists = SWAPI::Client.query(PostByID, variables: { id: id }).data.post
    pp "post already saved, moving on..." if record_exists
    next if record_exists

    # divs only have classes
    # which seem to be minimized and might change on each build
    # so instead, get children
    # but there could be times when certain children are missing
    # so we need a way to verify content of these
    data = post.css('div[data-ft="{\"tn\":\"H\"}"]').children[0]
    img_div = post.css('div[data-ft="{\"tn\":\"H\"}"]').children[1]
    imgs = img_div.children.map do |img|
      img.children[0].attributes['src'].text
    end
    price_int = data.children[1].children[0].text.gsub!(/[^0-9.]/, '').to_i

    title = data.children[0].children[1].text
    price = price_int.zero? ? nil : price_int
    location = data.children[2].text
    # remove variations of Mtl, QC
    location.gsub!(/[Mm]ont[-]?[rR]([eé]|oy)al/, '') if location
    location.gsub!(/[qQ]([cC]|u[eé]bec)/, '') if location
    if location.match(/[a-zA-z0-9]/)
      location += ', '
    else
      location = ''
    end
    location += 'Montréal, Québec'
    # @TODO: add .click on More text to load full description
    text = data.children[3].children[0].text
    link = "https://facebook.com/groups/#{group}/permalink/#{id}"

    result = SWAPI::Client.query(CreatePost, variables: { 
      data: {
        id: id,
        groupId: group,
        title: title,
        price: price,
        location: location,
        images: imgs.to_s,
        text: text,
        link: link
      }
    })

    while !result.errors && !result.data do
      result
    end

    pp "error!: #{result.errors.all.to_json}" if result.errors.all
    
    pp "saved: #{result.data.create_post.post.to_json}" if result.data
  end
end
