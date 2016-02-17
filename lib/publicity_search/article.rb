class PublicitySearch::Article

  @@articles = {}

  def initialize(site, max_articles, search_terms)
    @site = site
    @max_articles = max_articles
    @search_terms = search_terms
  end

  def self.all
    @@articles
  end

  def scrape_articles
    run_scraper(@max_articles, @category)
    search(@search_terms)
  end

  def run_scraper(max_articles, site)
    if @site == "deadline"
      dl = PublicitySearch::Deadline.new(max_articles)
      dl.user_prompt
      dl.scrape_all
      dl.add_to_articles
    end
  end

  def search(search_terms)
    @@articles.each do |site_name, articles|
      articles.each.with_index(1) do |article, index|
        if article.full_text.match(/\b#{search_terms}\b/i)
          puts "-----"
          puts "#{index}. " + article.title.gsub(/\b#{search_terms}\b/i, "#{search_terms.split.map(&:capitalize).join(' ').colorize(:yellow).colorize(:background => :red)}") + "[#{article.date_published}]"
          puts
          puts article.full_text.gsub(/\b#{search_terms}\b/i, "#{search_terms.split.map(&:capitalize).join(' ').colorize(:yellow).colorize(:background => :red)}")
          puts
          puts "#{article.url}"
          puts "-----"
        end
      end
    end
  end

end
