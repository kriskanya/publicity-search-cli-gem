class PublicitySearch::CLI

  def call
    search
    list_articles
    menu
    goodbye
  end

  def search
    puts "Publicity Search:"
    puts "Which topic would you like to search? e.g., 'Hugh Jackman'"
  end

  def list_articles
    @articles = PublicitySearch::Article.all
    @articles.each.with_index(1) do |article, index|
      puts "#{index}. #{article.title}"
      puts "#{article.abstract}"
    end
  end

  def menu
    puts "Enter the number of the article you'd like more info, or type 'list' to see the article list again, or type 'exit' to exit"
    input = ""
    while input != "exit"
      input = gets.strip.downcase

      if input.to_i > 0
        puts @articles[input.to_i-1]
      elsif input == "list"
        list_articles
      else
        puts "Type the article number, 'list', or 'exit'."
      end
    end
  end

  def goodbye
    puts 'Goodbye'
  end

end