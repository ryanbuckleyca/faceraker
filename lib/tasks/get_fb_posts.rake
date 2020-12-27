desc "Fetch ads"
task :fetch_ads => :environment do
  require 'rubygems'
  require 'mechanize'
  require 'dotenv'
  
  agent = Mechanize.new
  agent.user_agent_alias = 'Android'
  login_page = agent.get('https://m.facebook.com/')
  login_form = agent.page.form_with(:method => 'POST')
  login_form.email = 'ryanbuckley@gmail.com'
  login_form.pass = ENV['FB_PASS']
  page = agent.submit(login_form)
  pp page
  # add check to see if Not Now even exists first?
  agent.page.link_with(:text => 'Not Now').click
  cessation_page = agent.get('https://www.facebook.com/groups/263590541122539')
  main_div = cessation_page.css("div#m_group_stories_container")
  main_div.css("div[role='article']").each_with_index do |post, i|
    puts "--------- AD ##{i} -----------"
    post_link = post.css('div[data-ft="{\"tn\":\"*s\"}"]').children[0]
    post_data = post.css('div[data-ft="{\"tn\":\"H\"}"]').children[0]
    post_imgs = post.css('div[data-ft="{\"tn\":\"H\"}"]').children[1]

    post_title = post_data.children[0].children[1].text
    post_price = post_data.children[1].children[0].text
    post_text = post_data.children[3].children[0].text
    puts "Title: #{post_title}"
    puts "Price: #{post_price}"
    puts "Text: #{post_text}"
    pp post_link
  end
end