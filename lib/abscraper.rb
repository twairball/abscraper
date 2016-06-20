require "abscraper/version"
require "watir-webdriver"
require "mechanize"

module Abscraper
  class Abscraper

    def initialize(url:)
      @url = :url || "https://www.airbnb.com/rooms/9911289"

      listing_page = Abscraper::ListingPage(url: @url)
      listing_page.scrape_page
      
    end

    def crawl
      # TODO
    end

    def next_page
      # TODO
    end

  end
end

# watir extensions
require 'watir/element_locator'

# lib
require 'abscraper/models'
require 'abscraper/pages'
