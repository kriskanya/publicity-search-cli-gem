##Planning the app

###Here were some of my notes as I approached the project:

A command line interface for finding articles on a specific topic on 
publicity sites, such as deadline.

user types publicity-search
user inputs a string for what they want to search
user inputs a date range, e.g., 12/13/15-1/15/16
user selects a site they want to search (starting with deadline)

"Hugh Jackman" was mentioned 5 time(s) on deadline.

1. Hugh Jackman gets married
2. Hugh Jackman likes to work out.
3.
4.
5.

Which story would you like to view?
1

What is an article?
An article has:
 - title
 - author
 - date published
 - full article link
 - comments

##Coding the App

* ./bin/publicity_search calls CLI.new.call to start the app
* The CLI class takes care of all the CLI interaction and display
* The Article class was created to kick off the Deadline scraper, and direct traffic to different sites
I'd like to scrape in the future
* I decided to create a Deadline class, which directs the Deadline HTML to the proper scraper
(DeadlineTvMovies or DeadlineAwardsline)
* DeadlineTvMovies and DeadlineAwardsline both inherit from Base, as all articles have the following
characteristics: :title, :author, :date_published, :url, :excerpt, :full_text, :comments
  - DeadlineAwardsline object instances don't have an :excerpt property
