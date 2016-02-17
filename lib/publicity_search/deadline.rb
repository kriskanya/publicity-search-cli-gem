class PublicitySearch::Deadline < PublicitySearch::Base
  attr_accessor :selected_category, :max_articles

  PAGES = { 
            "film": "http://deadline.com/v/film/",
            "tv": "http://deadline.com/v/tv/",
            "awards-line": "http://deadline.com/v/awards/",
            "box-office": "http://deadline.com/v/box-office/",
            "business": "http://deadline.com/v/business/",
            "international": "http://deadline.com/v/international/"
          }

  @@all = []

  def initialize(max_articles)
    @max_articles = max_articles
  end

  def self.all
    @@all
  end

  def user_prompt
    puts "Which category? (i.e., film, tv, awards-line, box-office, business, international)"
    @selected_category = gets.strip.downcase
  end

  def scrape_all
    if @selected_category == "film" || 
      @selected_category == "tv" || 
      @selected_category == "box-office" || 
      @selected_category == "business" ||
      @selected_category == "international"

      scrape_tvmovies
    elsif @selected_category == "awards-line"
      scrape_awardsline
    end
  end

  def scrape_tvmovies
    full_url = PAGES[@selected_category.to_sym]
    page_number = 1

    while
      html = Nokogiri::HTML(open(full_url + "page/#{page_number}/"))

      html.search('.post').each do |post|
        return if @@all.length >= @max_articles
        ps = PublicitySearch::DeadlineTvMovies.new(post)
        # sometimes the articles actually redirect to the awardsline page
        # if Nokogiri::HTML(open(ps.url)).text.include?('Awards News')
          # @@all << scrape_awardsline
        # else
        @@all << ps.scrape_page(post)
        # end
      end
      page_number += 1
    end
  end

  def scrape_awardsline
    full_url = PAGES[@selected_category.to_sym]
    page_number = 1

    while
      html = Nokogiri::HTML(open(full_url + "page/#{page_number}/"))

      html.search('.river-entry').each do |post|
        return if @@all.length >= @max_articles
        @@all << PublicitySearch::DeadlineAwardsline.new.scrape_page(post)
      end
      page_number += 1
    end
  end

  def add_to_articles
    PublicitySearch::Article.all[:deadline] ||= []
    @@all.each do |deadline_article|
      PublicitySearch::Article.all[:deadline] << deadline_article
    end
  end

end
