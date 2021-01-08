desc 'Fetch ads'
task :fetch_ads => :environment do
  require 'rubygems'
  require 'mechanize'
  require 'dotenv'
  require 'net/http'
  require 'uri'
  require 'json'

  agent = Mechanize.new
  agent.user_agent = 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36'
  agent.get('https://m.facebook.com/')
  login_form = agent.page.form_with(:method => 'POST')
  login_form.email = 'ryanbuckley@gmail.com'
  puts "env is loaded" if ENV['FB_PASS']
  login_form.pass = ENV['FB_PASS']
  agent.submit(login_form)
  # add check to see if Not Now even exists first?
  # TODO: cannot connect to Facebook from Heroku
  # IP address isn't recognized by FB, so I get logged out
  # will have to run locally, then push DB to Production?
  # might be best to do that with the frontend
  # run this locally on my machine with shell script
  # then run front end push
  # https://www.reddit.com/r/facebook/comments/kqcvla/cannot_login_to_account_from_another_ip/
  # https://www.facebook.com/help/community/question/?id=411802246907577&added&rdrhc
  agent.page.link_with(:text => 'Not Now').click

  # app could be expanded to mutliple groups
  groups = [
    '263590541122539'
  ]

  groups.each do |group|
    user_group = Group.find_by_id(group)
    user_group_posts = user_group.posts
    cessation_page = agent.get("https://www.facebook.com/groups/#{group}")
    cessation_page.css("div[role='article']").each_with_index do |post, i|
      puts "--------- AD ##{i + 1} -----------"

      id = JSON.parse(post['data-ft'])['mf_story_key']
      next if user_group_posts.find_by_id(id)

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
      # TODO: add .click on More text to load full description
      text = data.children[3].children[0].text
      link = "https://facebook.com/groups/#{group}/permalink/#{id}"

      puts "Title: #{title}"
      puts "Price: #{price}"
      puts "Location: #{location}"
      puts "Images: #{imgs}"
      puts "Text: #{text}"
      puts "Link: #{link}"

      post = Post.create!(
        id: id,
        group: user_group,
        title: title,
        price: price,
        location: location,
        images: imgs,
        text: text,
        link: link
      )

      query = "mutation {
        createPostMutation(
          input:{
            id: #{post.id},
            groupId: #{post.group.id},
            title:\"#{post.title.gsub('"', '\"')}\",
            price: #{post.price},
            location: \"#{post.location.gsub('"', '\"')}\",
            longitude: #{post.longitude},
            latitude: #{post.latitude},
            images: \"#{post.images.gsub('"', '\"')}\",
            text: \"#{post.text.gsub('"', '\"')}\",
            link: \"#{post.link.gsub('"', '\"')}\"
          }
        ) {
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
      }"
      uri = URI("https://louwer-api.herokuapp.com/graphql?#{query}")
      
      puts "uri is: #{uri}"
    end
  end
end
