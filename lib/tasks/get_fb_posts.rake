desc "Fetch ads"
task :fetch_ads => :environment do
  require 'rubygems'
  require 'mechanize'
  require 'dotenv'
  require 'json'
  
  agent = Mechanize.new
  agent.user_agent = 'Mozilla/5.0 (Linux; Android 4.4.2; Nexus 4 Build/KOT49H) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.114 Mobile Safari/537.36'
  login_page = agent.get('https://m.facebook.com/')
  login_form = agent.page.form_with(:method => 'POST')
  login_form.email = 'ryanbuckley@gmail.com'
  login_form.pass = ENV['FB_PASS']
  page = agent.submit(login_form)
  # add check to see if Not Now even exists first?
  agent.page.link_with(:text => 'Not Now').click

  groups = [
    '263590541122539'
  ]

  groups.each do |group|
    cessation_page = agent.get("https://www.facebook.com/groups/#{group}")
    cessation_page.css("div[role='article']").each_with_index do |post, i|
      puts "--------- AD ##{i+1} -----------"

      post_id = JSON.parse(post["data-ft"])['mf_story_key']
      # divs only have classes
      # which seem to be minimized and might change on each build
      # so instead, get children
      # but there could be times when certain children are missing
      # so we need a way to verify content of these
      post_data = post.css('div[data-ft="{\"tn\":\"H\"}"]').children[0]
      post_imgs = post.css('div[data-ft="{\"tn\":\"H\"}"]').children[1]
      
      post_title = post_data.children[0].children[1].text
      post_price = post_data.children[1].children[0].text
      post_location = post_data.children[2].text
      post_text = post_data.children[3].children[0].text
      post_link = "https://m.facebook.com/groups/#{group}/permalink/#{post_id}"

      puts "Title: #{post_title}"
      puts "Price: #{post_price}"
      puts "Location: #{post_location}"
      puts "Images: #{post_imgs.children.count}"
      puts "Text: #{post_text}"
      puts "Link: #{post_link}"
    end
  end
end