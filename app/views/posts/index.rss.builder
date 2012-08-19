xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "dbjobs"
    xml.description "Job Postings"
    xml.link '/posts/posts.rss'
    
    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.description
        xml.pubDate post.created_at.to_s(:rfc822)
        xml.link post_path(post)
        xml.guid post_path(post)
      end
    end
  end
end