class PublicitySearch::DeadlineTvMovies < PublicitySearch::Base

  def initialize(post)
    self.url = post.search('.excerpt-link-wrapper').first.attributes['href'].value
  end

  def scrape_page(post)
    self.title = post.search('.post-title').text
    self.author = post.search('.author').map { |author| author.text }
    self.date_published = post.search('.date-published').text
    self.excerpt = post.search('.excerpt').text.gsub(/\n|\t/, "")
    
    full_text = Nokogiri::HTML(open(url)).search('.post-content > p').text
    if full_text.match(/Recent Comments/)
      self.full_text = full_text.gsub(/\n|\t/, "").split(/Recent Comments/).first
    else
      self.full_text = full_text
    end

    self.comments = 
      (
        comments = Nokogiri::HTML(open(url + "#respond")).search('#comment-list-wrapper p')

        if !comments.empty?
          comments = comments.map { |comment| comment.text }
        end
        comments
      )

    self
  end

end