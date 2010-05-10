xml.instruct!
xml.rss("version" => "2.0", "xmlns:dc" => "http://purl.org/dc/elements/1.1/") do
  xml.channel do
    xml.title "Ratan Sebastian's Posts"
    xml.link BLOG_BASE
    xml.description "This is a feed of all the posts that I push to my personal website"
    xml.language "en-gb"

    @posts.each do |post|
      xml.item do
        xml.pubDate post.created_at.to_time.rfc822
        xml.title Rack::Utils.escape_html(post.title)
        xml.link post.permalink
        xml.guid post.permalink
        xml.description do
          xml << Rack::Utils.escape_html(post.snippet)
        end
      end
    end
  end
end
