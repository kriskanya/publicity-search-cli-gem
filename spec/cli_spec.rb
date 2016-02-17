require 'spec_helper'

describe PublicitySearch do
  it 'has a version number' do
    expect(PublicitySearch::VERSION).not_to be nil
  end

  context PublicitySearch::CLI do
    let(:cli){PublicitySearch::CLI.new}

    describe '#greet_user' do
      it 'welcomes the user and prompts him to search' do
        expect{cli.greet_user}.to output("Welcome to Publicity Search!\nWhich site would you like to search? (i.e., deadline)\n").to_stdout
      end
    end

    describe '#get_user_input' do
      it 'should obtain the user input for the search' do
      end
    end

    describe '#search' do
      let(:article){PublicitySearch::Article.new('deadline', 2, 'the')}

      it 'should return all the articles in the current search' do
        expect(article.length).to be(2)
      end
      it 'should scrape the articles' do
        expect(article.scrape_articles).to include('1.')
        expect(article.scrape_articles).to include('2.')
      end
    end
  end
  
end