class Abscraper::ListingPage
  attr_accessor :listing, :page

  def initialize(url: nil)
    agent = Mechanize.new
    @page = agent.get(url)
  end

  def scrape_page
    # title, desc
    name = @page.at("h1[itemprop=name]").text
    desc = @page.at("#details").css("span")[1].text # details in 2nd span, after "About this listing"

    # province, district, city
    address_string = @page.at("#display-address")["data-location"]
    
    # beds, bedrooms, home/apt, capacity
    room_type = @page.css("#summary").css("div.col-sm-3")[4].text
    capacity = @page.css("#summary").css("div.col-sm-3")[5].text.split("Guests").first.chop
    bedrooms = @page.css("#summary").css("div.col-sm-3")[6].text.split("Bedroom").first.chop
    beds = @page.css("#summary").css("div.col-sm-3")[7].text.split("Bed").first.chop

    # get photos, will get top 5 or so only to reduce load
    # full photo gallery hidden behind a modal gallery
    photos = []
    @page.css(".photo-grid-photo > img").each do |photo_node|
      
      # remove cdn prcessing
      photos << photo_node["src"].split("?").first      
    end

    ## initialize listing object and return
    @listing = Abscraper::Listing.new(name: name, desc: desc, room_type: room_type, 
        capacity: capacity, bedrooms: bedrooms, beds: beds, photos: photos)
  end

end
