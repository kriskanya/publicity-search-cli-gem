class PublicitySearch::DeadlineAwardsline < PublicitySearch::Base

  def scrape_page(post)
    self.url = post.search('.content').css('a')[1].attributes['href'].value
    self.title = post.search('.hed').text
    self.author = post.search('.author').map { |author| author.text }
    self.date_published = post.search('.post-datetime').text.gsub(/on|am/, "").strip
    self.excerpt = ""
    self.full_text = Nokogiri::HTML(open(url)).search('.entry-post-content p').text.gsub(/\n|\t/, "")
    self.comments =
      (
        comments = Nokogiri::HTML(open(url)).search('.comment-list').search('.comment-content p')

        if !comments.empty?
          comments = comments.map { |comment| comment.text }
        end
        comments
      )

    self
  end

end