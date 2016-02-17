class PublicitySearch::CLI

  def call
    greet_user
    get_user_input
    search
    menu
    goodbye
  end

  def greet_user
    puts "Welcome to Publicity Search!"
    puts "Which site would you like to search? (i.e., deadline)"
  end

  def get_user_input
    @site = gets.chomp.downcase
    puts "How many articles would you like to search through?"
    @max_articles = gets.chomp.to_i
    puts "Search terms?"
    @search_terms = gets.chomp
  end

  def search
    @current_search = PublicitySearch::Article.new(@site, @max_articles, @search_terms)
    @current_search.scrape_articles
  end

  def list_articles
    @current_search = PublicitySearch::Article.all

    if @current_search.length == 0
      puts @current_search.articles
    else
      @current_search.each do |site, articles|
        articles.each.with_index(1) do |article, index|
          puts "#{index}. #{article.title}"
          puts
          puts "#{article.excerpt}"
          puts
        end
      end
    end
  end

  def help
    puts <<-STR
      Enter the number of the article you'd like more info on, or
      type 'search' to search again, or
      type 'list' to see the article list, or
      type 'exit' to exit
      STR
  end

  def menu
    help
    input = gets.strip
    while input != "exit"

      if input.to_i > 0
        display(input)
      elsif input == "list"
        list_articles
      elsif input == "search"
        call
      else
        puts "Type the article number, 'list', or 'exit'."
      end
      help
      input = gets.strip
    end
  end

  def display(input)
    a = PublicitySearch::Article.all[@site.to_sym][input.to_i-1]

    puts "#{input.to_i}. #{a.title}"
    a.author.each {|a| puts a}
    puts "#{a.date_published}"
    puts
    puts "#{a.full_text}"
    puts
    puts "#{a.url}"
  end

  def goodbye
    puts 'Goodbye'
  end

end