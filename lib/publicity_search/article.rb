class PublicitySearch::Article
  attr_accessor :title, :author, :date_published, :url, :excerpt, :full_text, :comments

  @@articles = {}
  PAGES = {"film": "http://deadline.com/v/film/", "tv": "http://deadline.com/v/tv/", 
           "awards-line": "http://deadline.com/v/awards/", "box-office": "http://deadline.com/v/box-office/",
           "business": "http://deadline.com/v/business/", "international": "http://deadline.com/v/international/"}

  def self.scrape_articles
    # scrape deadline and then return article info
    # go to deadline, find the articles
    # extract the properties
    # instantiate an article

    puts "How many articles would you like to search through?"
    max_articles = gets.chomp.to_i
    puts "Which category?"
    category = gets.chomp
    puts "Search terms?"
    search_terms = gets.chomp

    self.start_scraper(max_articles, category)
    self.search(search_terms)

    binding.pry
  end

  def self.search(search_terms)
    @@articles.each do |site_name, articles|
      articles.each do |article|
        if article.full_text.match(/\b#{search_terms}\b/i)
          puts "-----"
          puts "#{index ||= 1}. " + article.title.gsub(/\b#{search_terms}\b/i, "#{search_terms.split.map(&:capitalize).join(' ').colorize(:yellow).colorize(:background => :red)}") + "[#{article.date_published}]"
          puts
          puts article.full_text.gsub(/\b#{search_terms}\b/i, "#{search_terms.split.map(&:capitalize).join(' ').colorize(:yellow).colorize(:background => :red)}")
          puts
          puts "#{article.url}"
          puts "-----"
          index += 1
        end
      end
    end
  end

  def self.start_scraper(max_articles, selected_category)
    @@articles[:deadline] ||= []

    if selected_category == "film" || selected_category == "tv" || 
      selected_category == "box-office" || selected_category == "business" ||
      selected_category == "international"
      self.scrape_deadline_film_tv(PAGES[selected_category.to_sym], max_articles)
    elsif selected_category == "awards-line"
      self.scrape_deadline_awardsline(PAGES[selected_category.to_sym], max_articles)
    end
  end

  def self.scrape_deadline_film_tv(page_url, max_articles)
    html = Nokogiri::HTML(open(page_url))

    html.search('.post').each do |post|
      break if @@articles[:deadline].length >= max_articles
      article = self.new

      article.url = post.search('.excerpt-link-wrapper').first.attributes['href'].value
      # call other method in case an article is actually on AwardsLine
      # if Nokogiri::HTML(open(article.url)).search('.site-title').text.match(/awardsline/i)
      #   self.scrape_deadline_awardsline(page_url, max_articles)
      #   break
      # end

      article.title = post.search('.post-title').text
      article.author = post.search('.author').map { |author| author.text }
      article.date_published = post.search('.date-published').text
      article.excerpt = post.search('.excerpt').text
      article.full_text = Nokogiri::HTML(open(article.url)).search('.post-content p').text
      article.comments = Nokogiri::HTML(open(article.url + "#respond")).search('#comment-list-wrapper p')

      if !article.comments.empty?
        article.comments = article.comments.map { |comment| comment.text }
      end # end if
    @@articles[:deadline] << article
    end # end each
  end

  def self.scrape_deadline_awardsline(page_url, max_articles)
    html = Nokogiri::HTML(open(page_url))

    html.search('.river-entry').each do |entry|
      break if @@articles[:deadline].length >= max_articles
      article = self.new

      article.url = entry.search('.content').css('a')[1].attributes['href'].value
      article.title = entry.search('.hed').text
      article.author = entry.search('.author').map { |author| author.text }
      article.date_published = entry.search('.post-datetime').text.gsub(/on|am/, "").strip
      article.excerpt = ""
      article.full_text = Nokogiri::HTML(open(article.url)).search('.entry-post-content p').text
      article.comments = Nokogiri::HTML(open(article.url)).search('.comment-list').search('.comment-content p')

      if !article.comments.empty?
        article.comments = article.comments.map { |comment| comment.text }
      end

      @@articles[:deadline] << article
    end

  end
  # PublicitySearch::Article.start_scraper(2, "awardsline")

end